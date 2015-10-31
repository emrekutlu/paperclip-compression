module PaperclipCompression
  class Jpeg < Base

    JPEGTRAN_DEFAULT_OPTS = '-copy none -optimize -perfect'

    def initialize(file, first_processor, options = {})
      super(file, first_processor, options)
      @cli_opts = init_cli_opts(:jpeg, default_opts)
    end

    def make
      begin
        process_file? ? process_file : unprocessed_tempfile
      rescue Cocaine::ExitStatusError => e
        raise Paperclip::Error, "JPEGTRAN : There was an error processing #{@basename}" if @whiny
      rescue Cocaine::CommandNotFoundError => e
        raise Paperclip::Errors::CommandNotFoundError.new("Could not run 'jpegtran'. Please install jpegtran.")
      end
    end

    private

    def default_opts
      JPEGTRAN_DEFAULT_OPTS
    end

    def process_file
      # close dst file, so jpegtran can write it
      @dst.close
      Paperclip.run(command_path('jpegtran'), "#{@cli_opts} :src_path > :dst_path", src_path: @src_path, dst_path: @dst_path)
      @dst.open
      @dst
    end
  end
end
