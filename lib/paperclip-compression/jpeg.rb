module PaperclipCompression
  class Jpeg < Base

    JPEGTRAN_DEFAULT_OPTS = '-copy none -optimize -perfect'

    def initialize(file, options = {})
      super(file, options)

      @dst = Tempfile.new(@basename)
      @dst.binmode

      @src_path = File.expand_path(@file.path)
      @dst_path = File.expand_path(@dst.path)

      @cli_opts = init_cli_opts(:jpeg, default_opts)
    end

    def make
      begin
        if @cli_opts
          Paperclip.run(command_path('jpegtran'), "#{@cli_opts} :src_path > :dst_path", src_path: @src_path, dst_path: @dst_path)
          @dst
        else
          @file
        end
      rescue Cocaine::ExitStatusError => e
        raise Paperclip::Error, "JPEGTRAN : There was an error processing the thumbnail for #{@basename}" if @whiny
      rescue Cocaine::CommandNotFoundError => e
        raise Paperclip::Errors::CommandNotFoundError.new("Could not run 'jpegtran'. Please install jpegtran.")
      end
    end

    private

    def default_opts
      JPEGTRAN_DEFAULT_OPTS
    end

  end
end
