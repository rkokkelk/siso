class RecordsController < ApplicationController
  include CryptoHelper
  include RecordsHelper

  # GET /records/1
  # GET /records/1.json
  def show
  end

  # POST /records
  # POST /records.json
  def create

    if session[params[:id]].nil?
      flash[:notice] = 'Something went wrong'
      redirect_to(controller: :repositories, action: :show)
    else
      # Warning: rack automatically writes to a TempFile.
      # File content should be written to memory a.s.a.p and TempFile Removed
      file = params[:file]
      file_name = file.original_filename
      file_io = file.read
      file.close true

      # Ensure unique token for each file
      token = generate_token
      until valid_token token
        token = generate_token
      end

      @record = Record.new(file_name: file_name)
      @record.iv = generate_iv
      @record.token = token
      @record.size = file_io.size.to_s
      @record.creation = DateTime.now
      @record.repositories_id = Repository.find_by(token: params[:id]).id

      key = b64_decode session[params[:id]]
      encrypted_io = encrypt_aes_256(@record.iv, key, file_io, false)

      @record.encrypt_data b64_decode(session[params[:id]])

      if @record.save
        write_record(@record.token, encrypted_io)
        flash[:notice] = 'File was successfully uploaded'
        redirect_to(controller: :repositories, action: :show, id: params[:id])
      else
        flash[:alert] = 'Something went wrong'
        redirect_to(controller: :repositories, action: :show, id: params[:id])
      end
    end
  end

  # DELETE /records/1
  # DELETE /records/1.json
  def destroy
    @record.destroy
    respond_to do |format|
      format.html { redirect_to records_url, notice: 'Record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def record_params
      params.require(:record).permit(:file_name)
    end
end
