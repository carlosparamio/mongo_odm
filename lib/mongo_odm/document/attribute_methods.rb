# encoding: utf-8
require 'active_support/core_ext/hash/indifferent_access'

module MongoODM
  module Document
    module AttributeMethods

      extend ActiveSupport::Concern
      extend ActiveSupport::Autoload
      
      autoload :Read
      autoload :Write
      autoload :Query
      autoload :Dirty
      autoload :Inspect
      autoload :Localization

      included do
        include ActiveModel::AttributeMethods
        include AttributeMethods::Read
        include AttributeMethods::Write
        include AttributeMethods::Query
        include AttributeMethods::Dirty
        include AttributeMethods::Inspect
        include AttributeMethods::Localization
      end

      module InstanceMethods
        attr_reader :attributes

        def initialize(attrs = {})
          @attributes = {:_class => self.class.name}.with_indifferent_access
          load_attributes_or_defaults(attrs)
          self
        end

        def force_attributes=(new_attributes)
          send(:attributes=, new_attributes, true)
        end

        def attributes=(new_attributes, auto_generate_attributes = false)
          return if new_attributes.blank?
          new_attributes.each do |name, value|
            if respond_to?(:"#{name}=")
              send(:"#{name}=", value)
            else
              auto_generate_attributes ? write_attribute(name, value) : raise(MongoODM::Errors::UnknownFieldError, name, self.class)
            end
          end
        end

        def freeze
          @attributes.freeze; super
        end

        def has_attribute?(name)
          @attributes.has_key?(name)
        end
      
        def load_attributes_or_defaults(attrs)
          attrs = self.class.default_attributes.merge(attrs)
          self.force_attributes = attrs
        end
      
        def remove_attribute(name)
          @attributes.delete(name)
        end

        def method_missing(method_id, *args, &block)
          # If we haven't generated any methods yet, generate them, then
          # see if we've created the method we're looking for.
          if !self.class.attribute_methods_generated?
            self.class.define_attribute_methods_for_fields
            method_name = method_id.to_s
            guard_private_attribute_method!(method_name, args)
            send(method_id, *args, &block)
          else
            super
          end
        end
        
        def respond_to?(*args)
          self.class.define_attribute_methods_for_fields
          super
        end
        
        def attribute_method?(attr_name)
          attr_name == '_id' || attributes.include?(attr_name)
        end
        protected :attribute_method?
      end
    
      module ClassMethods
        def default_attributes
          HashWithIndifferentAccess[fields.values.map{|field| [field.name, field.default]}]
        end
        
        def define_attribute_methods_for_fields
          define_attribute_methods(fields.keys + [:_id, :_class])
        end
      end
    
    end
  end
end
