class RecordsController < ApplicationController
  include CryptoHelper
  include RecordsHelper
  include AuditHelper

  before_action :authentication
  before_action :set_objects,    only: [:show, :create, :delete]

  # GET /:id/:record_id
  def show
    key = session_key(@repository)
    @record.decrypt_data key

    file_name = @record.file_name
    file_ext = get_mime_type file_name
    file_io = decrypt_aes_256(@record.iv,
                              key,
                              read_record(@record.token),
                              false)
    send_data(file_io,
              filename: file_name,
              type: file_ext)

    audit_log(@repository.token, translate(:audit_file_accessed))
  end

  # POST /:id/record
  def create
    file = params[:file]
    verify_file_type file

    key = session_key @repository
    @record = Record.new(file_name: file.original_filename,
                         size: file.tempfile.size.to_s,
                         repositories_id: @repository.id,
                         key: key)

    if @record.save
      encrypted_io = encrypt_aes_256(@record.iv, key, file.read, false)

      write_record(@record.token, encrypted_io)
      audit_log(@repository.token, translate(:audit_file_created))
    else
      message = ''
      @record.errors.full_messages.each do |msg|
        message += "#{msg}\n"
      end

      flash[:alert] = message
    end

    redirect_to(controller: :repositories, action: :show, id: @repository.token)
  end

  # DELETE /:id/:record_id
  def delete
    if @record.destroy
      audit_log(@repository.token, translate(:audit_file_deleted))
    else
      flash[:alert] = translate :error
    end

    redirect_to(controller: :repositories, action: :show, id: @repository.token)
  end

  private

  def set_objects
    @repository = Repository.find_by(token: params[:id])
    @record = Record.find_by(repositories_id: @repository, token: params[:record_id])
  end

  def verify_file_type(file)
    # Rake test automatically generate Tempfile, for tests this is allowed
    # other instances should be reported immediately
    if !Rails.env.test? && !file.tempfile.is_a?(StringIO)
      file.close true if file.tempfile.is_a?(Tempfile)

      error = 'Tempfile is not a StringIO instance, could lead to information disclosure on hard drive'
      logger.error(error)
      raise SecurityError, error
    end
  end
end