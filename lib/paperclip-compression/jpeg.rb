module PaperclipCompression
  class Jpeg < Base

    KEY = :jpeg
    JPEGTRAN_DEFAULT_OPTS = '-copy none -optimize -perfect'

    def initialize(file, first_processor, options = {})
      super(file, first_processor)
      @config = PaperclipCompression::Config.create_with_fallbacks(options, KEY, gem_defaults)
    end

    def make
      begin
        @config.process_file? ? process_file : unprocessed_tempfile
      rescue Terrapin::ExitStatusError => e
        raise Paperclip::Error, "JPEGTRAN : There was an error processing #{@basename}" if @config.whiny
      rescue Terrapin::CommandNotFoundError => e
        raise Paperclip::Errors::CommandNotFoundError.new("Could not run 'jpegtran'. Please install jpegtran.")
      end
    end

    private

    def gem_defaults
      {
        command: command_path('jpegtran'),
        options: JPEGTRAN_DEFAULT_OPTS
      }
    end

    def compress
      Paperclip.run(
        @config.command,
        "#{@config.options} :src_path > :dst_path",
        src_path: @src_path, dst_path: @dst_path
      )
    end
  end
end
