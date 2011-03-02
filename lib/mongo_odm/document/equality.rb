# encoding: utf-8
module MongoODM
  module Document
    module Equality

      extend ActiveSupport::Concern

      module InstanceMethods
        def eql?(other)
          # Comparing attributes manually since Ruby Mongo driver doesn't support DBRef objects comparison
          return false if attributes.keys != other.attributes.keys
          attributes.each_pair do |key, value|
            if value.is_a?(BSON::DBRef) and other.attributes[key].is_a?(BSON::DBRef)
              return false if value.to_hash != other.attributes[key].to_hash
              next
            end
            return false if value != other.attributes[key]
          end

          other.is_a?(self.class) && _id == other._id
        end
        alias :== :eql?
        
        def hash
          _id.hash
        end
      end

    end
  end
end
