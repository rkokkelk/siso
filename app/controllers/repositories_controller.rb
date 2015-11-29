require 'base64'

class RepositoriesController < ApplicationController
  include CryptoHelper

  before_action :set_repository, only: [:show]

  # GET /repositories/b01e604fce20e8dab976a171fcce5a82
  # GET /repositories/b01e604fce20e8dab976a171fcce5a82.json
  def show
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

    respond_to do |format|
      if @repository.save
        format.html { redirect_to({:action => "show", :id => @repository.token}, notice: 'Repository was successfully created.') }
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
      params.require(:repository).permit(:title_enc, :description, :password)
    end
end
