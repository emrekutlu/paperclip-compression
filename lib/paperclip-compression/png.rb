module PaperclipCompression
  class Png < Base

    OPTIPNG_DEFAULT_OPTS  = '-o 5'

    def initialize(file, options = {})
      super(file, options)
      @src_path = File.expand_path(@file.path)
      @cli_opts = init_cli_opts(:png, default_opts)
    end

    def make
      begin
        Paperclip.run(command_path('optipng'), "#{@cli_opts} :src_path", src_path: @src_path) if @cli_opts
        @file
      rescue Cocaine::ExitStatusError => e
        raise Paperclip::Error, "OPTIPNG : There was an error processing the thumbnail for #{@basename}" if @whiny
      rescue Cocaine::CommandNotFoundError => e
        raise Paperclip::Errors::CommandNotFoundError.new("Could not run 'optipng'. Please install optipng.")
      end
    end

    private

    def default_opts
      OPTIPNG_DEFAULT_OPTS
    end

  end
end
