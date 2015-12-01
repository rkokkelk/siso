class RecordsController < ApplicationController
  include CryptoHelper
  include RecordsHelper

  # GET /repository/:id/records/:record_id
  def show
    if not authenticated? params
      flash[:notice] = 'Something went wrong'
      redirect_to(controller: :repositories, action: :show)
    else
      # Todo: cleanup, multiple finds
      @repository = Repository.find_by(token: params[:id])
      @records = Record.where(repositories_id: @repository)
      @records.each do |record|
        record.decrypt_data b64_decode(session[params[:id]])
        if record.token == params[:record_id]
          @record = record
          break
        end
      end

      file_name = @record.file_name
      file_ext = get_mime_type file_name
      file_io = decrypt_aes_256(@record.iv,
                                b64_decode(session[params[:id]]),
                                read_record(@record.token),
                                false)
      send_data(file_io,
                :filename => file_name,
                :type => file_ext)
    end
  end

  # POST /repository/:id/records
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
      while token_exist token
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

  # DELETE /repository/:id/records/:record_id
  def delete

    if not authenticated? params
      flash[:notice] = 'Something went wrong'
      redirect_to(controller: :repositories, action: :show)
    else

      # Todo: cleanup, multiple finds
      @repository = Repository.find_by(token: params[:id])
      @records = Record.where(repositories_id: @repository)
      @records.each do |record|
        record.decrypt_data b64_decode(session[params[:id]])
        if record.token == params[:record_id]
          @record = record
          break
        end
      end

      if @record.destroy
        remove_record params[:record_id]
        flash[:notice] = 'File was successfully removed'
        redirect_to(controller: :repositories, action: :show, id: params[:id])
      else
        flash[:alert] = 'Cannot delete file, something went wrong'
        redirect_to(controller: :repositories, action: :show, id: params[:id])
      end
    end
  end

  private

    # Todo cleanup authentication
    def authenticated?(params)
      found = false
      @repository = Repository.find_by(token: params[:id])

      # First verify if the user is allowed to access the requested
      # repository
      if session[params[:id]].nil?
        return false
      end

      # Verify if the request record is
      # related to the requested repository
      @records = Record.where(repositories_id: @repository)
      @records.each do |record|
        record.decrypt_data b64_decode(session[params[:id]])
        if record.token == params[:record_id]
          found = true
          break
        end
      end

      return found
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def record_params
      params.require(:record).permit(:file_name)
    end
end
