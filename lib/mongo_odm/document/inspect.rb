# encoding: utf-8
require 'active_support/core_ext/hash/except'

module MongoODM
  module Document
    module Inspect

      extend ActiveSupport::Concern

      module ClassMethods
        def inspect
          "#{name}(#{fields.map{|k, v| "#{k}: #{v.type}"}.join(", ")})"
        end
      end
    
      module InstanceMethods
        def private_attribute_names
          %w(_class)
        end
      
        def inspect
          "#<#{self.class.name} #{attributes.except(*private_attribute_names).keys.sort.map{|k| inspect_attribute(k)}.join(", ")}>"
        end
      end

    end
  end
end
