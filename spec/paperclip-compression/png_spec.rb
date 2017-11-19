RSpec.describe PaperclipCompression::Png do

  before(:each) do
    path = File.join(PaperclipCompression.root, 'spec', 'support', 'test.png')
    @file = File.new(path, 'rb')
    @key = PaperclipCompression::Png::PNG_KEY
  end

  after(:each) do
    @file.close
  end

  it 'processes the file via embedded binary' do
    PaperclipCompression::Png.new(@file, false).make
  end

  context 'when Paperclip default options are set' do

    context 'and style based options are set' do
      it 'uses style based options' do
        with_paperclip_default_options(@key => '--abc') do
          expect(Paperclip).to receive(:run).with(anything, run_options('--xyz'), anything)

          jpeg = PaperclipCompression::Png.new(@file, false, style_options(@key => '--xyz'))
          jpeg.make
        end
      end
    end

    context 'and style based options are not set' do
      it 'uses Paperclip default options' do
        with_paperclip_default_options(@key => '--abc') do
          expect(Paperclip).to receive(:run).with(anything, run_options('--abc'), anything)

          jpeg = PaperclipCompression::Png.new(@file, false)
          jpeg.make
        end
      end
    end

    context 'and style based options are true' do
      it 'uses style Paperclip default options' do
        with_paperclip_default_options(@key => '--abc') do
          expect(Paperclip).to receive(:run).with(anything, run_options('--abc'), anything)

          jpeg = PaperclipCompression::Png.new(@file, false, style_options(@key => true))
          jpeg.make
        end
      end
    end

    context 'and style based options is false' do
      it 'does not process the file' do
        with_paperclip_default_options(@key => '--abc') do
          expect(Paperclip).not_to receive(:run)

          jpeg = PaperclipCompression::Png.new(@file, false, style_options(@key => false))
          jpeg.make
        end
      end
    end

    context 'and style based options is nil' do
      it 'does not process the file' do
        with_paperclip_default_options(@key => '--abc') do
          expect(Paperclip).not_to receive(:run)

          jpeg = PaperclipCompression::Png.new(@file, false, style_options(@key => nil))
          jpeg.make
        end
      end
    end

    context 'and style based options are blank string' do
      it 'processes the file without additional options' do
        with_paperclip_default_options(@key => '--abc') do
          expect(Paperclip).to receive(:run).with(anything, run_options(''), anything)

          jpeg = PaperclipCompression::Png.new(@file, false, style_options(@key => ''))
          jpeg.make
        end
      end
    end
  end

  context 'when Paperclip default options are not set' do
    context 'and style based options are set' do
      it 'uses style based options' do
        expect(Paperclip).to receive(:run).with(anything, run_options('--xyz'), anything)

        jpeg = PaperclipCompression::Png.new(@file, false, style_options(@key => '--xyz'))
        jpeg.make
      end
    end

    context 'and style based options are not set' do
      it 'uses PaperclipCompression default options' do
        expect(Paperclip).to receive(:run).with(anything, run_options(PaperclipCompression::Png::OPTIPNG_DEFAULT_OPTS), anything)

        jpeg = PaperclipCompression::Png.new(@file, false)
        jpeg.make
      end
    end

    context 'and style based options are true' do
      it 'uses style PaperclipCompression default options' do
        expect(Paperclip).to receive(:run).with(anything, run_options(PaperclipCompression::Png::OPTIPNG_DEFAULT_OPTS), anything)

        jpeg = PaperclipCompression::Png.new(@file, false, style_options(@key => true))
        jpeg.make
      end
    end

    context 'and style based options is false' do
      it 'does not process the file' do
        expect(Paperclip).not_to receive(:run)

        jpeg = PaperclipCompression::Png.new(@file, false, style_options(@key => false))
        jpeg.make
      end
    end

    context 'and style based options is nil' do
      it 'does not process the file' do
        expect(Paperclip).not_to receive(:run)

        jpeg = PaperclipCompression::Png.new(@file, false, style_options(@key => nil))
        jpeg.make
      end
    end

    context 'and style based options are blank string' do
      it 'processes the file without additional options' do
        expect(Paperclip).to receive(:run).with(anything, run_options(''), anything)

        jpeg = PaperclipCompression::Png.new(@file, false, style_options(@key => ''))
        jpeg.make
      end
    end
  end

  def run_options(opts)
    "#{opts} -clobber :src_path -out :dst_path"
  end

end
