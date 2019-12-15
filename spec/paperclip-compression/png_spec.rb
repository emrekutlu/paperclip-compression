RSpec.describe PaperclipCompression::Png do

  before(:each) do
    path = File.join(PaperclipCompression.root, 'spec', 'support', 'test.png')
    @file = File.new(path, 'rb')
    @key = PaperclipCompression::Png::KEY
  end

  after(:each) do
    @file.close
  end

  it 'processes the file via embedded binary' do
    PaperclipCompression::Png.new(@file, false, whiny: true).make
  end

  it 'does not process if command exists but config.process_file? is false' do
    expect(PaperclipCompression::Config).to receive(:create_with_fallbacks).and_return(
      instance_double(PaperclipCompression::Config, :process_file? => false, command: 'command')
    )

    expect(Paperclip).not_to receive(:run)
    PaperclipCompression::Png.new(@file, false).make
  end

  it 'uses config command and options' do
    options = {
      PaperclipCompression::Config::PROCESSOR_OPTIONS_KEY => {
        PaperclipCompression::Config::KEY => {
          PaperclipCompression::Png::KEY => {
            command: 'abc',
            options: 'xyz'
          }
        }
      }
    }

    expect(Paperclip).to receive(:run).with('abc', 'xyz -clobber :src_path -out :dst_path', anything)
    PaperclipCompression::Png.new(@file, false, options).make
  end

end
