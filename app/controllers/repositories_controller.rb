require 'base64'
require 'date'

class RepositoriesController < ApplicationController
  include CryptoHelper
  include AuditHelper

  before_action :ip_authentication,       only: [:new, :create]
  before_action :authentication,          only: [:show, :delete, :audit]
  before_action :set_decrypt_repository,  only: [:show, :delete, :audit]

  # GET /repositories/b01e604fce20e8dab976a171fcce5a82
  def show

    @records = Record.where(repositories_id: @repository)
    @records.each do |record|
      record.decrypt_data @repository.master_key
    end

    if @repository.days_to_deletion <= 7   # Display warning if repository is deleted within 1 week
      flash.now[:alert] = "Repository will deleted within #{@repository.days_to_deletion+1} day(s)."
    end
  end

  # GET /repositories/b01e604fce20e8dab976a171fcce5a82/audit
  def audit
    @audit = read_logs(@repository.token)
  end

  # GET /repositories/new
  def new
    @repository = Repository.new
  end

  def show_authenticate
    render :authenticate
  end

  # POST /repositories/b01e604fce20e8dab976a171fcce5a82/authenticate
  def authenticate
    @repository = Repository.find_by(token: params[:id]).try(:authenticate, params[:password])

    if @repository
      reset_session

      @repository.decrypt_master_key params[:password]
      set_session_key @repository

      redirect_to({action: :show, :id => @repository.token})
    else
      # Perform resource intensive task equal to other if
      # to prevent side-channel information leakage
      password = generate_token
      BCrypt::Password.create(password)
      pbkdf2(generate_iv, password)

      flash.now[:alert] = 'Login failed. Please verify the correct URL and password.'
      render :authenticate
    end
  end

  # POST /repositories/b01e604fce20e8dab976a171fcce5a82
  def create
    @repository = Repository.new(repository_params)

    if repository_params[:password].blank? then @repository.generate_password end
    @repository.encrypt_master_key

    if @repository.save
      reset_session

      if repository_params[:password].blank?
        flash[:notice] = 'A password has been generated. This password will only be shown once so save it somewhere securely.'
        flash[:alert] = "Password: #{@repository.password}"
      end

      set_session_key @repository
      audit_log(@repository.token, 'Repository created')

      redirect_to(action: :show, :id => @repository.token)
    else
      render :new
    end
  end

  # DELETE /repositories/b01e604fce20e8dab976a171fcce5a82
  def delete
    if @repository.destroy
      audit_log(@repository.token, 'Repository deleted')
      redirect_to(controller: :main, action: :index)
    else
      flash[:alert] = 'Something went wrong'
      redirect_to(action: :show, :id => @repository.token)
    end
  end

  private
    def set_decrypt_repository
      @repository = Repository.find_by(token: params[:id])
      @repository.master_key = get_session_key @repository
      @repository.decrypt_data
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def repository_params
      params.require(:repository).permit(:title, :description, :password, :password_confirmation)
    end
end
