module PaperclipHelper

  def with_paperclip_default_options(opts)
    Paperclip::Attachment.default_options[PaperclipCompression::Base::PROCESSOR_OPTIONS_KEY] = opts
    yield
    Paperclip::Attachment.default_options.delete(PaperclipCompression::Base::PROCESSOR_OPTIONS_KEY)
  end

  def style_options(opts)
    { processor_options: { PaperclipCompression::Base::PROCESSOR_OPTIONS_KEY => opts } }
  end

end
