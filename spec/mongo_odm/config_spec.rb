# encoding: utf-8
require "spec_helper"

describe MongoODM::Config do
  before do
    @config = { :host => 'localhost', :port => 9000 }
    MongoODM.config = @config
  end

  after do
    MongoODM.config = {}
  end

  it 'should set the configuration' do
    MongoODM.config.host.should == @config[:host]
    MongoODM.config.port.should == @config[:port]
  end
end