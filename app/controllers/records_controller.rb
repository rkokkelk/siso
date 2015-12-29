class RecordsController < ApplicationController
  include CryptoHelper
  include RecordsHelper

  before_action :authentication,  only: [:show, :create, :delete]
  before_action :set_objects,     only: [:show, :delete]

  # GET /repository/:id/records/:record_id
  def show
    @record.decrypt_data b64_decode(session[params[:id]])

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

  # POST /repository/:id/records
  def create

    # Warning: rack automatically writes to a TempFile.
    # File content should be written to memory a.s.a.p and TempFile Removed
    file = params[:file]
    file_name = file.original_filename
    file_io = file.read
    file.close true

    @record = Record.new(file_name: file_name)

    @record.setup
    @record.size = file_io.size.to_s
    @record.repositories_id = Repository.find_by(token: params[:id]).id

    key = b64_decode session[params[:id]]
    encrypted_io = encrypt_aes_256(@record.iv, key, file_io, false)

    @record.encrypt_data b64_decode(session[params[:id]])

    if @record.save
      write_record(@record.token, encrypted_io)
      flash[:notice] = 'File was successfully uploaded'
    else
      flash[:alert] = @record.errors.full_messages['file_name']
    end

    redirect_to(controller: :repositories, action: :show, id: params[:id])
  end

  # DELETE /repository/:id/records/:record_id
  def delete

    if @record.destroy
      flash[:notice] = 'File was successfully removed'
    else
      flash[:alert] = 'Cannot delete file, something went wrong'
    end

    redirect_to(controller: :repositories, action: :show, id: params[:id])
  end

  private
  def set_objects
    @repository = Repository.find_by(token: params[:id])
    @record = Record.find_by(repositories_id: @repository, token: params[:record_id])
  end
end