require 'base64'
require 'date'

class RepositoriesController < ApplicationController
  include CryptoHelper

  before_action :set_repository, only: [:authenticate]

  # GET /repositories/b01e604fce20e8dab976a171fcce5a82
  # GET /repositories/b01e604fce20e8dab976a171fcce5a82.json
  def show

    if session[params[:id]].nil?
      flash[:alert] = 'Please login'
      render :authenticate
    else
      @repository = Repository.find_by(token: params[:id])
      @repository.master_key = b64_decode session[params[:id]]
      @repository.decrypt_data

      @records = Record.where(repositories_id: @repository)
      @records.each do |record|
        record.decrypt_data @repository.master_key
      end
    end
  end

  # GET /repositories/new
  def new

    if IpHelper.verifyIP request.ip
      @repository = Repository.new
    else
      redirect_to(controller: :main, action: :index)
    end
  end

  # POST /repositories/b01e604fce20e8dab976a171fcce5a82/authenticate
  def authenticate

    if @repository and @repository.authenticate(params[:password])
      reset_session

      master_key = @repository.decrypt_master_key(params[:password])
      session[@repository.token] = b64_encode master_key

      redirect_to({:action => 'show', :id => @repository.token})
    else
      flash[:alert] = 'Login failed. Please verify the correct URL and password.'
      render :authenticate
    end
  end

  # POST /repositories/b01e604fce20e8dab976a171fcce5a82
  # POST /repositories.json
  def create

    if IpHelper.verifyIP request.ip

      @repository = Repository.new(repository_params)

      @repository.iv = generate_iv
      @repository.token = generate_token
      @repository.master_key = generate_key
      @repository.creation = DateTime.now
      @repository.deletion = DateTime.now >> 1 # Add 1 month

      @repository.encrypt_master_key repository_params[:password]
      session[@repository.token] = b64_encode @repository.master_key

      if @repository.save
        redirect_to({:action => 'show', :id => @repository.token}, notice: 'Repository was successfully created.')
      else
        render :new
      end
    else
      redirect_to(controller: :main, action: :index)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_repository
      @repository = Repository.find_by(token: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def repository_params
      params.require(:repository).permit(:title, :description, :password, :password_confirmation)
    end
end
