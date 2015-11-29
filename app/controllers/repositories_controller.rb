require 'base64'

class RepositoriesController < ApplicationController
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

    @repository.created = Time.now

    @repository.iv = SecureRandom.hex 16
    @repository.token = SecureRandom.hex 16
    @repository.master_key_clear = SecureRandom.random_bytes(32)
    #@repository.master_key = Base64.encode64(SecureRandom.random_bytes(32)).force_encoding('UTF-8')

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
      params.require(:repository).permit(:title, :description, :pass)
    end
end
