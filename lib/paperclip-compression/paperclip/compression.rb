module Paperclip
  # Compresses the JPEG and PNG files
  class Compression < Processor

    def make
      case content_type
      when 'image/jpeg' then make_jpeg
      when 'image/png'  then make_png
      else
        @file
      end
    end

    private

    def content_type
      first_processor? ? @file.content_type : Paperclip::ContentTypeDetector.new(@file.path).detect
    end

    def first_processor?
      @first_processor ||= @file.is_a?(Paperclip::AbstractAdapter)
    end

    def make_jpeg
      PaperclipCompression::Jpeg.make(@file, first_processor?, @options)
    end

    def make_png
      PaperclipCompression::Png.make(@file, first_processor?, @options)
    end

  end
end
