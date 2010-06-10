# encoding: utf-8
require 'mongo_odm'

module MongoODM
  module Document

    extend ActiveSupport::Concern
    extend ActiveSupport::Autoload

    autoload :Associations
    autoload :AttributeMethods
    autoload :Callbacks
    autoload :Fields
    autoload :Inspect
    autoload :Persistence
    autoload :Validations

    included do
      include ActiveModel::Conversion
      include ActiveModel::Serializers::JSON
      include ActiveModel::Serializers::Xml
      include ActiveModel::Observing
      include ActiveModel::Translation
      include MongoODM::Document::Persistence
      include MongoODM::Document::AttributeMethods
      include MongoODM::Document::Fields
      include MongoODM::Document::Inspect
      include MongoODM::Document::Associations
      include MongoODM::Document::Callbacks
      include MongoODM::Document::Validations
    end

  end
end