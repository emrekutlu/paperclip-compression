RSpec.describe PaperclipCompression::Config do

  describe '#create_with_fallbacks' do
    it 'combines style, default and gem options' do
      type_key = :abc

      style_options = {
        PaperclipCompression::Config::PROCESSOR_OPTIONS_KEY => {
          PaperclipCompression::Config::KEY => {
            type_key => true
          }
        }
      }

      Paperclip::Attachment.default_options[PaperclipCompression::Config::KEY] = {
        type_key => '--options'
      }

      gem_defaults = { command: 'def' }

      config = PaperclipCompression::Config.create_with_fallbacks(style_options, type_key, gem_defaults)

      expect(config.options).to eq('--options')
      expect(config.command).to eq('def')

      Paperclip::Attachment.default_options.delete(PaperclipCompression::Config::KEY)
    end
  end

  it 'options overwrites fallback' do
    fallback = new_config({ command: 'abc', options: '--best' }, :abc, nil, false)
    config = new_config({ command: 'xyz', options: '--opt' }, :abc, fallback, false)

    expect(config.process_file?).to eq(true)
    expect(config.command).to eq('xyz')
    expect(config.options).to eq('--opt')
  end

  it 'fallback is used when options does not have attributes' do
    fallback = new_config({ command: 'abc', options: '--best' }, :abc, nil, false)
    config = new_config({}, :abc, fallback, false)

    expect(config.process_file?).to eq(true)
    expect(config.command).to eq('abc')
    expect(config.options).to eq('--best')
  end

  it 'options can prevent processing when fallback exists with false' do
    fallback = new_config({ command: 'abc', options: '--best' }, :abc, nil, false)
    config = new_config(false, :abc, fallback, false)

    expect(config.process_file?).to eq(false)
    expect(config.command).to eq('abc')
    expect(config.options).to eq('--best')
  end

  it 'options can prevent processing when fallback exists with nil' do
    fallback = new_config({ command: 'abc', options: '--best' }, :abc, nil, false)
    config = new_config(nil, :abc, fallback, false)

    expect(config.process_file?).to eq(false)
    expect(config.command).to eq('abc')
    expect(config.options).to eq('--best')
  end

  it 'when options is true, it uses fallback' do
    fallback = new_config({ command: 'abc', options: '--best' }, :abc, nil, false)
    config = new_config(true, :abc, fallback, false)

    expect(config.process_file?).to eq(true)
    expect(config.command).to eq('abc')
    expect(config.options).to eq('--best')
  end

  it 'uses both options and fallback' do
    fallback = new_config({ options: '--best' }, :abc, nil, false)
    config = new_config({ command: 'nbc' }, :abc, fallback, false)

    expect(config.process_file?).to eq(true)
    expect(config.command).to eq('nbc')
    expect(config.options).to eq('--best')
  end

  it 'transforms string values to options' do
    fallback = new_config({ command: 'asd' }, :abc, nil, false)
    config = new_config('--opts', :abc, fallback, false)

    expect(config.process_file?).to eq(true)
    expect(config.command).to eq('asd')
    expect(config.options).to eq('--opts')
  end

  it 'transforms empty string values to empty options' do
    fallback = new_config({ command: 'asd' }, :abc, nil, false)
    config = new_config('', :abc, fallback, false)

    expect(config.process_file?).to eq(true)
    expect(config.command).to eq('asd')
    expect(config.options).to eq('')
  end

  it 'raises when both options and fallback are empty' do
    fallback = PaperclipCompression::Config.new({ PaperclipCompression::Config::KEY => {} }, :abc, nil, false)
    config = PaperclipCompression::Config.new({ PaperclipCompression::Config::KEY => {} }, :abc, fallback, false)

    expect do
      config.process_file?
    end.to raise_error('options or fallback should have attributes')

    expect do
      config.command
    end.to raise_error("options or fallback should have 'command'")

    expect do
      config.options
    end.to raise_error("options or fallback should have 'options'")
  end

  it 'fallbacks when KEY is true' do
    fallback = new_config({ command: 'def', options: 'opts' }, :abc, nil, false)
    config = PaperclipCompression::Config.new({ PaperclipCompression::Config::KEY => true }, :abc, fallback, false)

    expect(config.process_file?).to eq(true)
    expect(config.command).to eq('def')
    expect(config.options).to eq('opts')
  end

  it 'does not process when KEY is false' do
    fallback = new_config({ command: 'def', options: 'opts' }, :abc, nil, false)
    config = PaperclipCompression::Config.new({ PaperclipCompression::Config::KEY => false }, :abc, fallback, false)

    expect(config.process_file?).to eq(false)
    expect(config.command).to eq('def')
    expect(config.options).to eq('opts')
  end

  it 'does not process when KEY is nil' do
    fallback = new_config({ command: 'def', options: 'opts' }, :abc, nil, false)
    config = PaperclipCompression::Config.new({ PaperclipCompression::Config::KEY => false }, :abc, fallback, false)

    expect(config.process_file?).to eq(false)
    expect(config.command).to eq('def')
    expect(config.options).to eq('opts')
  end

  it 'sets whiny' do
    config = new_config('--opts', :abc, nil, true)
    expect(config.whiny).to eq(true)
  end

  def new_config(options, key, fallback, whiny)
    options = { PaperclipCompression::Config::KEY => { key => options } }
    PaperclipCompression::Config.new(options, key, fallback, whiny)
  end

end
