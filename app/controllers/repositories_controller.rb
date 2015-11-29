require 'base64'

class RepositoriesController < ApplicationController
  include CryptoHelper

  before_action :set_repository, only: [:show]

  # GET /repositories/b01e604fce20e8dab976a171fcce5a82
  # GET /repositories/b01e604fce20e8dab976a171fcce5a82.json
  def show

    if session[params[:id]].nil?
      raise SecurityError, 'You are not authenticated'
    end

    @repository.master_key = b64_decode session[params[:id]]
    @repository.decrypt_data
  end

  # GET /repositories/new
  def new
    @repository = Repository.new
  end

  # POST /repositories
  # POST /repositories.json
  def create
    @repository = Repository.new(repository_params)

    @repository.iv = generate_iv
    @repository.token = generate_token
    @repository.master_key = generate_key
    @repository.creation = Time.now

    session[@repository.token] = b64_encode @repository.master_key

    respond_to do |format|
      if @repository.save
        format.html { redirect_to({:action => 'show', :id => @repository.token}, notice: 'Repository was successfully created.') }
        format.json { render :show, status: :created, location: @repository }
      else
        format.html { render :new }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_repository
      @repository = Repository.find_by(token: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def repository_params
      params.require(:repository).permit(:title, :description, :password)
    end
end
