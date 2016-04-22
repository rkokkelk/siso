require 'base64'
require 'date'

class RepositoriesController < ApplicationController
  include CryptoHelper
  include AuditHelper
  include I18n

  before_action :ip_authentication,       only: [:new, :create]
  before_action :authentication,          only: [:show, :delete, :audit]
  before_action :set_decrypt_repository,  only: [:show, :delete, :audit]

  # GET /b01e604fce20e8dab976a171fcce5a82
  def show

    logger.debug{"Time zone: #{Time.zone}"}
    @records = Record.where(repositories_id: @repository)
    @records.each do |record|
      record.decrypt_data @repository.master_key
      logger.debug{"Current time: #{record.created_at.in_time_zone}"}
    end

    if @repository.days_to_deletion <= 7   # Display warning if repository is deleted within 1 week
      flash.now[:alert] = translate :repo_deletion
    end
  end

  # GET /b01e604fce20e8dab976a171fcce5a82/audit
  def audit
    @audit = read_logs(@repository.token)
  end

  # GET /new
  def new
    @repository = Repository.new
  end

  def show_authenticate
    render :authenticate
  end

  # POST /b01e604fce20e8dab976a171fcce5a82/authenticate
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

      flash.now[:alert] = translate :fail_login
      render :authenticate
    end
  end

  # POST /b01e604fce20e8dab976a171fcce5a82
  def create
    @repository = Repository.new(repository_params)

    @repository.generate_password if repository_params[:password].blank?
    @repository.encrypt_master_key

    if @repository.save
      reset_session

      if repository_params[:password].blank?
        flash[:notice] = translate :pass_generated
        flash[:alert] = translate(:pass_show, :pass => @repository.password)
      end

      set_session_key @repository
      audit_log(@repository.token, translate(:audit_repo_created))

      redirect_to(action: :show, :id => @repository.token)
    else
      render :new
    end
  end

  # DELETE /b01e604fce20e8dab976a171fcce5a82
  def delete
    if @repository.destroy
      audit_log(@repository.token, translate(:audit_repo_deleted))
      redirect_to(controller: :main, action: :index)
    else
      flash[:alert] = translate :error
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
