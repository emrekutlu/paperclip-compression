module PaperclipCompression

  ExitStatusError = defined?(Cocaine) ? Cocaine::ExitStatusError : Terrapin::ExitStatusError
  CommandNotFoundError = defined?(Cocaine) ? Cocaine::CommandNotFoundError : Terrapin::CommandNotFoundError

  class Base

    def initialize(file, first_processor)
      @file             = file
      current_extension = File.extname(file.path)
      @basename         = File.basename(file.path, current_extension)
      @dst              = Paperclip::TempfileFactory.new.generate(@basename)
      @dst_path         = File.expand_path(@dst.path)
      @src_path         = File.expand_path(@file.path)
      @first_processor  = first_processor
    end

    def self.make(file, first_processor, options = {})
      new(file, first_processor, options).make
    end

    def process_file
      # Close output file so compressors which require exclusive file rights
      # work.
      @dst.close

      # Execute the child-compressor classes implementation of how to compress
      # the output
      compress

      # Re-open the output file so downstream paperclip-middleware may
      # read/write/etc. without having to re-open the file.
      @dst.open

      # Return the destination file for downstream paperclip processors.
      @dst
    end

    protected

    def process_file?
      @cli_opts
    end

    def unprocessed_tempfile
      copy_to_tempfile
      first_processor? ? @dst : @file
    end

    def command_path(command)
     folder = if OS.osx?
        File.join('osx', catalina? ? '64bit' : '32bit')
      elsif OS.linux?
        File.join('linux', OS.bits.eql?(64) ? 'x64' : 'x86')
      elsif OS.windows?
        OS.bits.eql?(64) ? 'win64' : 'win32'
      end

      File.join(PaperclipCompression.root, 'bin', folder, command)
    end

    private

    def compress
      fail MustImplementInSubClassesException,
           'compress is overridden on a per compressor basis.'
    end

    def first_processor?
      @first_processor
    end

    def copy_to_tempfile
      FileUtils.cp(@src_path, @dst_path)
    end

    def catalina?
      major = OS.host_os.match(/darwin(\d+)/)[1].to_i
      major >= 19
    end
  end

  # Informs developers when a method is intended to be defined in # sub-classes.
  class MustImplementInSubClassesException < Exception; end
end
