# encoding: utf-8
require 'rubygems'
require 'mongo'
require 'active_support'
require 'active_model'

# Contains the classes and modules related to the ODM built on top of the basic Mongo client.
module MongoODM

  extend ActiveSupport::Autoload
  include ActiveSupport::Configurable

  autoload :VERSION
  autoload :Cursor
  autoload :Collection
  autoload :Document
  autoload :Errors
  
  def self.connection
    Thread.current[:mongo_odm_connection] ||= Mongo::Connection.new(config[:host], config[:port], config)
  end
  
  def self.connection=(value)
    Thread.current[:mongo_odm_connection] = value
  end
  
  def self.database
    connection.db(config[:database] || 'test')
  end
  
  def self.config=(value)
    self.connection = nil
    super
  end
  
  def self.instanciate(value)
    return nil if value.nil?
    return instanciate_doc(value) if value.is_a?(Hash)
    return value if value.class.included_modules.include?(MongoODM::Document)
    value.class.type_cast(value.to_mongo)
  end
  
  def self.instanciate_doc(doc)
    return doc if doc["_class"].nil?
    doc["_class"].constantize.new(doc)
  end

end