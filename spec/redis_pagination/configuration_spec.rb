require 'spec_helper'

describe RedisPagination::Configuration do
  describe '#configure' do
    it 'should have default attributes' do
      RedisPagination.configure do |configuration|
        configuration.page_size.should == 25
      end
    end
  end
end