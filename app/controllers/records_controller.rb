class RecordsController < ApplicationController
  include CryptoHelper
  include RecordsHelper
  include AuditHelper

  before_action :authentication
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

    audit_log(params[:id], translate(:audit_file_accessed))
  end

  # POST /repository/:id/records
  def create

    file = params[:file]

    unless file.tempfile.is_a?(StringIO)
      if file.tempfile.is_a?(Tempfile) then file.close true end
      raise SecurityError, 'Tempfile is not a StringIO instance, could lead to disclosure on hard drive'
    end

    if file.tempfile.size == 0
      flash[:alert] = translate :empty_file_error
      redirect_to(controller: :repositories, action: :show, id: params[:id])
      return
    end

    @record = Record.new(file_name: file.original_filename)

    @record.setup
    @record.size = file.tempfile.size.to_s
    @record.repositories_id = Repository.find_by(token: params[:id]).id

    @record.encrypt_data b64_decode(session[params[:id]])

    if @record.save
      key = b64_decode session[params[:id]]
      encrypted_io = encrypt_aes_256(@record.iv, key, file.read, false)

      write_record(@record.token, encrypted_io)
      audit_log(params[:id], translate(:audit_file_created))
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
      flash[:notice] = translate :file_removed
      audit_log(params[:id], translate(:audit_file_deleted))
    else
      flash[:alert] = translate :error
    end

    redirect_to(controller: :repositories, action: :show, id: params[:id])
  end

  private
  def set_objects
    @repository = Repository.find_by(token: params[:id])
    @record = Record.find_by(repositories_id: @repository, token: params[:record_id])
  end
end