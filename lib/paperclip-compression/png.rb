module PaperclipCompression
  class Png < Base

    OPTIPNG_DEFAULT_OPTS  = '-o 5 -quiet'

    def initialize(file, first_processor, options = {})
      super(file, first_processor, options)
      @cli_opts = init_cli_opts(:png, default_opts)
    end

    def make
      begin
        process_file? ? process_file : unprocessed_tempfile
      rescue Cocaine::ExitStatusError => e
        raise Paperclip::Error, "OPTIPNG : There was an error processing #{@basename}" if @whiny
      rescue Cocaine::CommandNotFoundError => e
        raise Paperclip::Errors::CommandNotFoundError.new("Could not run 'optipng'. Please install optipng.")
      end
    end

    private

    def default_opts
      OPTIPNG_DEFAULT_OPTS
    end

    def process_file
      Paperclip.run(command_path('optipng'), "#{@cli_opts} -clobber :src_path -out :dst_path", src_path: @src_path, dst_path: @dst_path)
      @dst
    end

  end
end
