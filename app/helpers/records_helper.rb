require 'fileutils'

module RecordsHelper
  include CryptoHelper

  def write_record(token, file_io)
    file_loc = file_location token
    IO.binwrite(file_loc, file_io)
  end

  def read_record(token)
    file_loc = file_location token
    IO.binread(file_loc)
  end

  def remove_record(token)

    if not token_exist token
      raise Exception, 'Unable to delete record, because it does not exist'
    else
      file_loc = file_location token
      FileUtils.rm file_loc
    end
  end

  def token_exist(token)
    file_loc = file_location token
    File.exist?(file_loc)
  end

  private
  def file_location(value)
    file_name = '%s.file' % value
    Rails.root.join('data', file_name)
  end
end
