module PaperclipCompression
  class Base

    def initialize(file, first_processor, options = {})
      @file             = file
      @options          = options
      @whiny            = options.has_key?(:whiny) ? options[:whiny] : true
      current_extension = File.extname(file.path)
      @basename         = File.basename(file.path, current_extension)
      @dst              = Paperclip::TempfileFactory.new.generate("#{@basename}.png")
      @dst_path         = File.expand_path(@dst.path)
      @src_path         = File.expand_path(@file.path)
      @first_processor  = first_processor
    end

    def self.make(file, first_processor, options = {})
      new(file, first_processor, options).make
    end

    protected

    def process_file?
      @cli_opts
    end

    def unprocessed_tempfile
      copy_to_tempfile
      first_processor? ? @dst : @file
    end

    def init_cli_opts(type, default_opts)
      # use default options in the papeclip config if exists, otherwise use gem defaults.
      default_opts = init_default_opts(Paperclip::Attachment.default_options, type, default_opts)
      # use processor_options if exists, otherwise use defaults.
      init_default_opts(@options[:processor_options], type, default_opts)
    end

    def command_path(command)
     folder = if OS.osx?
        'osx'
      elsif OS.linux? || RUBY_PLATFORM =~ /freebsd/
        File.join('linux', OS.bits.eql?(64) ? 'x64' : 'x86')
      elsif OS.windows?
        OS.bits.eql?(64) ? 'win64' : 'win32'
      end

      File.join(PaperclipCompression.root, 'bin', folder, command)
    end

    private

    def first_processor?
      @first_processor
    end

    def init_default_opts(opts, type, default_opts)
      if opts && (compression_opts = opts[:compression])
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

    def copy_to_tempfile
      FileUtils.cp(@src_path, @dst_path)
    end
  end
end
