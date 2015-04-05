require 'spec_helper'

describe Spaarti do
  describe '#new' do
    it 'creates a Site object' do
      expect(Spaarti.new).to be_an_instance_of Spaarti::Site
    end
  end
end
