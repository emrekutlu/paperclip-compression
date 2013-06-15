module Paperclip
  # Compresses the JPEG and PNG files
  class Compression < Processor

    def make
      case @attachment.content_type
      when 'image/jpeg' then make_jpeg
      when 'image/png'  then make_png
      else
        @file
      end
    end

    private

    def make_jpeg
      PaperclipCompression::Jpeg.make(@file, @options)
    end

    def make_png
      PaperclipCompression::Png.make(@file, @options)
    end

  end

end
