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
      flash.now[:alert] = translate :repo_deletion
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
    @repository = Repository.find_by(token: params[:id])

    if @repository and @repository.authenticate(params[:password])
      reset_session

      master_key = @repository.decrypt_master_key(params[:password])
      session[@repository.token] = b64_encode master_key

      redirect_to({action: :show, :id => @repository.token})
    else
      flash.now[:alert] = translate :fail_login
      render :authenticate
    end
  end

  # POST /repositories/b01e604fce20e8dab976a171fcce5a82
  def create
    @repository = Repository.new(repository_params)
    @repository.setup

    show_pass = false
    pass = repository_params[:password]
    if pass.blank?
      show_pass = true
      pass = generate_password
      @repository.password = pass
      @repository.password_confirmation = pass
    end

    @repository.encrypt_master_key pass

    if @repository.save
      reset_session

      if show_pass
        flash[:notice] = translate :pass_generated
        flash[:alert] = translate(:pass_show, :pass => pass)
      end

      session[@repository.token] = b64_encode @repository.master_key

      logger.debug{"Repository created: #{@repository.token}"}
      audit_log(@repository.token, translate(:audit_repo_created))

      redirect_to(action: :show, :id => @repository.token)
    else
      render :new
    end
  end

  # DELETE /repositories/b01e604fce20e8dab976a171fcce5a82
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
      @repository.master_key = b64_decode session[@repository.token]
      @repository.decrypt_data
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def repository_params
      params.require(:repository).permit(:title, :description, :password, :password_confirmation)
    end
end
