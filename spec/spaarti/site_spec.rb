require 'spec_helper'
require 'fileutils'

describe Spaarti do
  describe 'Site' do
    let(:path) { 'tmp/base' }
    let(:config) { 'spec/examples/config.yml' }
    let(:subject) { Spaarti::Site.new config_file: config }

    before(:each) do
      FileUtils.rm_rf path
      FileUtils.mkdir_p path
    end

    describe '#sync!' do
      it 'clones repo' do
        expect(File.exist?("#{path}/akerl/spaarti/.git")).to be_falsey
        VCR.use_cassette('repos') { subject.sync! }
        expect(File.exist?("#{path}/akerl/spaarti/.git")).to be_truthy
      end

      context 'with purge enabled' do
        it 'purges repos that are orphaned' do
          FileUtils.mkdir_p "#{path}/akerl/orphan/.git"
          VCR.use_cassette('repos') do
            Spaarti::Site.new(purge: true, config_file: config).sync!
          end
          expect(File.exist?("#{path}/akerl/orphan")).to be_falsey
        end
      end
      context 'with purge disabled' do
        it 'does not purge repos that are orphaned' do
          FileUtils.mkdir_p "#{path}/akerl/orphan/.git"
          VCR.use_cassette('repos') do
            Spaarti::Site.new(purge: false, config_file: config).sync!
          end
          expect(File.exist?("#{path}/akerl/orphan")).to be_truthy
        end
      end

      it 'supports excluding repos' do
        VCR.use_cassette('repos') do
          Spaarti::Site.new(
            exclude: { full_name: ['[ab]a'] }, config_file: config
          ).sync!
        end
        expect(File.exist?("#{path}/akerl/spaarti")).to be_falsey
      end
    end

    describe '#purge!' do
      it 'purges repos that are orphaned' do
        FileUtils.mkdir_p "#{path}/akerl/orphan/.git"
        VCR.use_cassette('repos') do
          Spaarti::Site.new(purge: true, config_file: config).sync!
        end
        expect(File.exist?("#{path}/akerl/orphan")).to be_falsey
      end
    end
  end
end
