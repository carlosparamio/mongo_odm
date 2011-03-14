# encoding: utf-8
require 'active_support/core_ext/module/aliasing'

module MongoODM
  module Document
    module Validations
      # Validates whether or not a field is unique against the documents in the
      # database.
      #
      # @example Define the uniqueness validator.
      #
      #   class Person
      #     include MongoODM::Document
      #     field :title
      #
      #     validates_uniqueness_of :title
      #   end
      class UniquenessValidator < ActiveModel::EachValidator

        # Unfortunately, we have to tie Uniqueness validators to a class.
        def setup(klass)
          @klass = klass
        end

        # Validate the document for uniqueness violations.
        #
        # @example Validate the document.
        #   validate_each(person, :title, "Sir")
        #
        # @param [ Document ] document The document to validate.
        # @param [ Symbol ] attribute The field to validate on.
        # @param [ Object ] value The value of the field.
        def validate_each(document, attribute, value)
          criteria = @klass.find(attribute => unique_search_value(value))
          unless document.new_record?
            criteria = criteria.find(:_id => {'$ne' => document._id})
          end

          Array.wrap(options[:scope]).each do |item|
            criteria = criteria.find(item => document.attributes[item])
          end
          if criteria.first
            document.errors.add(
              attribute,
              :taken,
              options.except(:case_sensitive, :scope).merge(:value => value)
            )
          end
        end

        protected

        # ensure :case_sensitive is true by default
        def unique_search_value(value)
          if options[:case_sensitive]
            value
          else
            value ? Regexp.new("^#{Regexp.escape(value.to_s)}$", Regexp::IGNORECASE) : nil
          end
        end
      end
    end
  end
end
