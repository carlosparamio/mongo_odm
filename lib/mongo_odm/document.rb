# encoding: utf-8
require 'mongo_odm'

module MongoODM
  module Document

    extend ActiveSupport::Concern
    extend ActiveSupport::Autoload

    autoload :AttributeMethods
    autoload :Callbacks
    autoload :Fields
    autoload :Indexes
    autoload :Inspect
    autoload :Persistence
    autoload :Timestamps
    autoload :Validations
    autoload :Equality

    included do
      include ActiveModel::Conversion
      include ActiveModel::Observing
      include ActiveModel::Translation

      include ActiveModel::Serializers::JSON
      include ActiveModel::Serializers::Xml

      include Document::Persistence
      include Document::AttributeMethods
      include Document::Fields
      include Document::Indexes
      include Document::Inspect
      include Document::Callbacks
      include Document::Validations
      include Document::Equality
    end

  end
end