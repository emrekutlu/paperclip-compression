require 'paperclip'

module Paperclip
  # Compresses the JPEG and PNG files
  class Compression < Processor

    JPEGTRAN_DEFAULT_OPTS = '-copy none -optimize -perfect'
    OPTIPNG_DEFAULT_OPTS  = '-o 5'

    attr_accessor :format, :jpegtran_opts, :optipng_opts

    def initialize(file, options = {}, attachment = nil)
      super
      @format         = options[:format]
      @current_format = File.extname(@file.path)
      @basename       = File.basename(@file.path, @current_format)

      if @options[:processor_options] && (compression_opts = @options[:processor_options][:compression])

        @jpegtran_opts = if compression_opts.has_key?(:jpeg)
          if (jpeg_opts = compression_opts[:jpeg])
            jpeg_opts.kind_of?(String) ? jpeg_opts : JPEGTRAN_DEFAULT_OPTS
          else
            false
          end
        else
          JPEGTRAN_DEFAULT_OPTS
        end

        @optipng_opts = if compression_opts.has_key?(:png)
          if (png_opts = compression_opts[:png])
            png_opts.kind_of?(String) ? png_opts : OPTIPNG_DEFAULT_OPTS
          else
            false
          end
        else
          OPTIPNG_DEFAULT_OPTS
        end

      else
        @jpegtran_opts  = JPEGTRAN_DEFAULT_OPTS
        @optipng_opts   = OPTIPNG_DEFAULT_OPTS
      end
    end

    def make
      case @attachment.content_type
      when 'image/jpeg' then process_jpegtran
      when 'image/png'  then process_optipgn
      else
        @file
      end
    end

    private

    def process_jpegtran
      src = @file
      dst = Tempfile.new([@basename, @format ? ".#{@format}" : ''])
      dst.binmode

      src_path = File.expand_path(src.path)
      dst_path = File.expand_path(dst.path)

      begin
        if @jpegtran_opts
          Paperclip.run('jpegtran', "#{@jpegtran_opts} #{src_path} > #{dst_path}")
          dst
        else
          src
        end
      rescue Cocaine::ExitStatusError => e
        raise Paperclip::Error, "JPEGTRAN : There was an error processing the thumbnail for #{@basename}" if @whiny
      rescue Cocaine::CommandNotFoundError => e
        raise Paperclip::Errors::CommandNotFoundError.new("Could not run 'jpegtran'.Please install jpegtran.")
      end
    end

    def process_optipgn
      src = @file
      src_path = File.expand_path(src.path)

      begin
        Paperclip.run('optipng', "#{@optipng_opts} #{src_path}") if @optipng_opts
        src
      rescue Cocaine::ExitStatusError => e
        raise Paperclip::Error, "OPTIPNG : There was an error processing the thumbnail for #{@basename}" if @whiny
      rescue Cocaine::CommandNotFoundError => e
        raise Paperclip::Errors::CommandNotFoundError.new("Could not run 'optipng'.Please install optipng.")
      end
    end

  end

end
