class RecordsController < ApplicationController
  include CryptoHelper
  include RecordsHelper
  include AuditHelper

  before_action :authentication
  before_action :set_objects,     only: [:show, :create, :delete]

  # GET /repository/:id/records/:record_id
  def show
    key = get_session_key(@repository)
    @record.decrypt_data key

    file_name = @record.file_name
    file_ext = get_mime_type file_name
    file_io = decrypt_aes_256(@record.iv,
                              key,
                              read_record(@record.token),
                              false)
    send_data(file_io,
              :filename => file_name,
              :type => file_ext)

    audit_log(params[:id], 'File downloaded')
  end

  # POST /repository/:id/records
  def create

    file = params[:file]

    unless file.tempfile.is_a?(StringIO)
      if file.tempfile.is_a?(Tempfile) then file.close true end
      raise SecurityError, 'Tempfile is not a StringIO instance, could lead to disclosure on hard drive'
    end

    if file.tempfile.size == 0
      flash[:alert] = 'It is not possible to upload empty files'
      redirect_to(controller: :repositories, action: :show, id: params[:id])
      return
    end

    key = get_session_key(@repository)
    @record = Record.new(file_name: file.original_filename)

    @record.setup
    @record.size = file.tempfile.size.to_s
    @record.repositories_id = @repository.id

    @record.encrypt_data key

    if @record.save
      encrypted_io = encrypt_aes_256(@record.iv, key, file.read, false)

      write_record(@record.token, encrypted_io)
      audit_log(params[:id], 'File uploaded')
    else

      message = ''
      @record.errors.full_messages.each do |msg|
        message += "#{msg}\n"
      end

      flash[:alert] = message
    end

    redirect_to(controller: :repositories, action: :show, id: params[:id])
  end

  # DELETE /repository/:id/records/:record_id
  def delete

    if @record.destroy
      flash[:notice] = 'File was successfully removed'
      audit_log(params[:id], 'File deleted')
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