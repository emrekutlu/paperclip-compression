module PaperclipCompression
  class Base

    def initialize(file, options = {})
      @file          = file
      @options       = options
      @whiny         = options.has_key?(:whiny) ? options[:whiny] : true
      current_format = File.extname(file.path)
      @basename      = File.basename(file.path, current_format)
    end

    def self.make(file, options = {})
      new(file, options).make
    end

    protected

    def init_cli_opts(type, default_opts)
      processor_opts = @options[:processor_options]
      if processor_opts && (compression_opts = processor_opts[:compression])
        if compression_opts.has_key?(type)
          if (type_opts = compression_opts[type])
            type_opts.kind_of?(String) ? type_opts : default_opts
          else
            false
          end
        else
          default_opts
        end
      else
        default_opts
      end
    end

    def command_path(command)
     folder = if OS.osx?
        'osx'
      elsif OS.linux?
        File.join('linux', OS.bits.eql?(64) ? 'x64' : 'x86')
      elsif OS.windows?
        OS.bits.eql?(64) ? 'win64' : 'win32'
      end

      File.join(PaperclipCompression.root, 'bin', folder, command)
    end

  end
end
