module PaperclipCompression
  class Png < Base

    KEY = :png
    OPTIPNG_DEFAULT_OPTS = '-o 5 -quiet'

    def initialize(file, first_processor, options = {})
      super(file, first_processor)
      @config = PaperclipCompression::Config.create_with_fallbacks(options, KEY, gem_defaults)
    end

    def make
      begin
        @config.process_file? ? process_file : unprocessed_tempfile
      rescue Terrapin::ExitStatusError => e
        raise Paperclip::Error, "OPTIPNG : There was an error processing #{@basename}" if @config.whiny
      rescue Terrapin::CommandNotFoundError => e
        raise Paperclip::Errors::CommandNotFoundError.new("Could not run 'optipng'. Please install optipng.")
      end
    end

    private

    def gem_defaults
      {
        command: command_path('optipng'),
        options: OPTIPNG_DEFAULT_OPTS
      }
    end

    def compress
      Paperclip.run(
        @config.command,
        "#{@config.options} -clobber :src_path -out :dst_path",
        src_path: @src_path, dst_path: @dst_path
      )
    end
  end
end
