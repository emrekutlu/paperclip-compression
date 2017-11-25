module PaperclipCompression
  class Config

    PROCESSOR_OPTIONS_KEY = :processor_options
    KEY = :compression

    def self.create_with_fallbacks(style_options, type_key, gem_defaults)
      gem_config = new({ KEY => { type_key => gem_defaults } }, type_key, nil, nil)
      defaults_config = new(Paperclip::Attachment.default_options, type_key, gem_config, Paperclip::Attachment.default_options[:whiny])
      new(style_options[PROCESSOR_OPTIONS_KEY], type_key, defaults_config, style_options[:whiny])
    end

    def initialize(options, type_key, fallback, whiny)
      @whiny = whiny
      @fallback = fallback
      parse_options(options, type_key)
    end

    def process_file?
      if defined?(@process_file)
        @process_file
      elsif @fallback
        @fallback.process_file?
      else
        raise('options or fallback should have attributes')
      end
    end

    def command
      if defined?(@command)
        @command
      elsif @fallback
        @fallback.command
      else
        raise("options or fallback should have 'command'")
      end
    end

    def options
      if defined?(@options)
        @options
      elsif @fallback
        @fallback.options
      else
        raise("options or fallback should have 'options'")
      end
    end

    def whiny
      @whiny
    end

    private

    def parse_options(options, type_key)
      if options && options.has_key?(KEY)
        compression_opts = options[KEY]

        if compression_opts.eql?(true)
          @process_file = true
        elsif compression_opts.eql?(false) || compression_opts.eql?(nil)
          @process_file = false
        elsif compression_opts.is_a?(Hash) && compression_opts.has_key?(type_key)
          parse_type_options(compression_opts[type_key])
        end
      end
    end

    def parse_type_options(type_opts)
      if type_opts
        @process_file = true

        if type_opts.is_a?(String)
          @options = type_opts
        elsif type_opts.is_a?(Hash)
          @command = type_opts[:command] if type_opts.has_key?(:command)
          @options = type_opts[:options] if type_opts.has_key?(:options)
        end
      else
        @process_file = false
      end
    end

  end
end
