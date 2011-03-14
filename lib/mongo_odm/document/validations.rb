# encoding: utf-8
require 'active_support/core_ext/module/aliasing'

module MongoODM
  module Document
    module Validations

      extend ActiveSupport::Concern
      extend ActiveSupport::Autoload
      
      autoload :UniquenessValidator

      included do
        include ActiveModel::Validations

        alias_method_chain :save, :validation
      end
    
      module InstanceMethods
        # The validation process on save can be skipped by passing false. The regular Base#save method is
        # replaced with this when the validations module is mixed in, which it is by default.
        def save_with_validation(options=nil)
          perform_validation = case options
            when NilClass
              true
            when Hash
              options[:validate] != false
          end

          if perform_validation && valid? || !perform_validation
            save_without_validation
          else
            false
          end
        end
      
        # Runs all the specified validations and returns true if no errors were added otherwise false.
        def valid?
          errors.clear
          run_callbacks(:validate)
          errors.empty?
        end
      end
      
      module ClassMethods
        # Validates whether or not a field is unique against the documents in the
        # database.
        #
        # @example
        #
        #   class Person
        #     include MongoODM::Document
        #     field :title
        #
        #     validates_uniqueness_of :title
        #   end
        #
        # @param [ Array ] *args The arguments to pass to the validator.
        def validates_uniqueness_of(*args)
          validates_with(UniquenessValidator, _merge_attributes(args))
        end
      end

    end
  end
end
