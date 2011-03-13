# encoding: utf-8
require 'rubygems'
require 'mongo'
require 'active_support'
require 'active_support/core_ext/hash'
require 'active_model'

# Contains the classes and modules related to the ODM built on top of the basic Mongo client.
module MongoODM

  extend ActiveSupport::Autoload

  autoload :VERSION
  autoload :Config
  autoload :Criteria
  autoload :Cursor
  autoload :Collection
  autoload :Document
  autoload :Errors

  def self.connection
    Thread.current[:mongo_odm_connection] ||= config.connection
  end

  def self.connection=(value)
    Thread.current[:mongo_odm_connection] = value
  end

  def self.database
    Thread.current[:mongo_odm_database] ||= self.connection.db( config.database )
  end

  def self.config
    @_config ||= Config.new
  end

  def self.config=(value)
    self.connection = nil
    @_config = value.is_a?(Config) ? value : Config.new(value)
  end

  def self.instanciate(value)
    return value if value.is_a?(MongoODM::Document)
    if value.is_a?(Hash)
      klass = value["_class"] || value[:_class]
      return klass.constantize.new(value) if klass
    end
    value.class.type_cast(value.to_mongo)
  end

  def self.dereference(value)
    value.respond_to?(:dereference) ? value.dereference : value
  end

end
