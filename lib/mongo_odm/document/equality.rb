# encoding: utf-8
module MongoODM
  module Document
    module Equality

      extend ActiveSupport::Concern

      module InstanceMethods
        def eql?(other)
          other.is_a?(self.class) && _id == other._id && attributes == other.attributes
        end
        alias :== :eql?
        
        def hash
          _id.hash
        end
      end

    end
  end
end
