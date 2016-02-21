require 'rack/utils'

module Rack
  module Multipart
    class Parser

      def get_current_head_and_filename_and_content_type_and_name_and_body
        head = nil
        body = ''

        if body.respond_to? :force_encoding
          body.force_encoding Encoding::ASCII_8BIT
        end

        filename = content_type = name = nil

        until head && @buf =~ rx
          if !head && i = @buf.index(EOL+EOL)
            head = @buf.slice!(0, i+2) # First \r\n

            @buf.slice!(0, 2)          # Second \r\n

            content_type = head[MULTIPART_CONTENT_TYPE, 1]
            name = head[MULTIPART_CONTENT_DISPOSITION, 1] || head[MULTIPART_CONTENT_ID, 1]

            filename = get_filename(head)

            if name.nil? || name.empty? && filename
              name = filename
            end

            if filename
              (@env['rack.tempfiles'] ||= []) << body = StringIO.new() # Patch
              body.binmode  if body.respond_to?(:binmode)
            end

            next
          end

          # Save the read body part.
          if head && (@boundary_size+4 < @buf.size)
            body << @buf.slice!(0, @buf.size - (@boundary_size+4))
          end

          content = @io.read(@content_length && @bufsize >= @content_length ? @content_length : @bufsize)
          raise EOFError, "bad content body"  if content.nil? || content.empty?

          @buf << content
          @content_length -= content.size if @content_length
        end

        [head, filename, content_type, name, body]
      end

    end
  end
end


