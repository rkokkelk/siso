require 'fileutils'
require 'mime/types'

module RecordsHelper
  include CryptoHelper

  def write_record(token, file_io)
    file_loc = file_location token
    IO.binwrite(file_loc, file_io)
  end

  def read_record(token)

    raise IOError, "Unable to read record (#{token}), does not exist" unless exists_token? token

    file_loc = file_location token
    IO.binread(file_loc)
  end

  def remove_record(token)

    raise IOError, "Unable to delete record (#{token}), does not exist" unless exists_token? token

    file_loc = file_location token
    FileUtils.rm file_loc
  end

  def exists_token?(token)
    file_loc = file_location token
    File.exist?(file_loc)
  end

  def get_mime_type(file_name)
    ext = File.extname(file_name)
    MIME::Types.type_for(ext)
  end

  private
  def file_location(value)
    file_name = '%s.file' % value
    Rails.root.join('data', file_name)
  end
end
