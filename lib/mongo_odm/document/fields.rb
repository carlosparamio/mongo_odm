# encoding: utf-8
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/hash/keys'
require 'mongo_odm/core_ext/conversions'

module MongoODM
  module Document
    module Fields

      extend ActiveSupport::Concern

      class Field
        # @return [Symbol] the name of this field in the Document.
        attr_reader :name
        # @return [Class] the Ruby type of field.
        attr_reader :type
        # @return [Hash] configuration options.
        attr_reader :options

        # Creates a new document field.
        # @param [String, Symbol] name the name of the field.
        # @param [Class] type the Ruby type of the field. It should respond to 'type_cast'. Use {Boolean} for true or false types.
        # @param [Hash] options configuration options.
        # @option options [Object, Proc] :default (nil) a default value for the field, or a lambda to evaluate when providing the default.
        def initialize(name, type, options = {})
          @name = name.to_sym
          @type = type
          @options = options.to_options
        end

        # @return [Object] The default value for this field if defined, or nil.
        def default
          if options.has_key?(:default)
            default = options[:default]
            type_cast(default.respond_to?(:call) ? default.call : default)
          end
        end

        # Attempt to coerce the passed value into this field's type
        # @param [Object] value the value to coerce
        # @return [Object] the value coerced into this field's type
        # @raise [MongoODM::Errors::TypeCastMissing] if the value cannot be coerced into the field's type
        def type_cast(value)
          raise MongoODM::Errors::TypeCastMissing.new(value, @type) unless @type.respond_to?(:type_cast)
          @type.type_cast(value)
        end
      end

      module ClassMethods
        def inherited(subclass)
          super
          subclass.fields.merge!(fields)
        end

        def fields
          @fields ||= {}.with_indifferent_access
        end

        def field(name, type = String, options = {})
          fields[name] = Field.new(name, type, options)
          fields[name]
        end
      end

    end
  end
end
