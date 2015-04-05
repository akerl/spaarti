require 'spec_helper'
require 'fileutils'

describe Spaarti do
  describe Site do
    let(:path) { 'spec/examples/base' }
    let(:subject) { Spaarti::Site.new config_file: 'spec/examples/config.yml' }

    before(:each) do
      FileUtils.rm_rf path
      FileUtils.mkdir_p path
    end

    describe '#sync!' do
      VCR.use_cassette('repos') do
        it 'clones repos' do
          subject.sync!
          expect(File.exist? File.join(path, 'spaarti', '.git')).to be_truthy
        end
      end
    end

    describe '#purge!' do
    end
  end
end
