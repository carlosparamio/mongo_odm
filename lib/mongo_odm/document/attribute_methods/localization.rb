# encoding: utf-8
require 'active_support/core_ext/hash/indifferent_access'

module MongoODM
  module Document
    module AttributeMethods
      module Localization

        extend ActiveSupport::Concern

        included do
          attribute_method_suffix "_localized?"
          attribute_method_suffix "_without_localization"

          alias_method_chain :read_attribute, :localization
          alias_method_chain :write_attribute, :localization
          alias_method_chain :inspect, :localization
        end
        
        module ClassMethods
          def define_method_attribute_localized?(attr_name)
            generated_attribute_methods.module_eval("def #{attr_name}_localized?; localized_attribute?('#{attr_name}'); end", __FILE__, __LINE__)
          end
          protected :define_method_attribute_localized?
          
          def define_method_attribute_without_localization(attr_name)
            generated_attribute_methods.module_eval("def #{attr_name}_without_localization; read_attribute_without_localization('#{attr_name}'); end", __FILE__, __LINE__)
          end
          protected :define_method_attribute_localized?
        end

        module InstanceMethods
          def localized_attribute?(attr_name)
            field = self.class.fields[attr_name]
            localized = field ? !!field.options[:localized] : false
            raise MongoODM::Errors::InvalidLocalizedField.new(field.name, field.type) if localized && field && field.type != Hash
            localized
          end
          
          def read_attribute_with_localization(attr_name, locale = nil)
            if localized_attribute?(attr_name)
              locale = I18n.locale || I18n.default_locale if locale.nil?
              (read_attribute_without_localization(attr_name) || {}.with_indifferent_access)[locale]
            else
              read_attribute_without_localization(attr_name)
            end
          end

          def write_attribute_with_localization(attr_name, value, locale = nil)
            if localized_attribute?(attr_name)
              locale = I18n.locale || I18n.default_locale if locale.nil?
              current_value = read_attribute_without_localization(attr_name) || {}.with_indifferent_access
              write_attribute_without_localization(attr_name, current_value.merge(locale => value))
            else
              write_attribute_without_localization(attr_name, value)
            end
          end
          
          def inspect_with_localization
            "#<#{self.class.name} #{attributes.except(*private_attribute_names).keys.map{|k| "#{localized_attribute?(k) ? "#{k}[#{I18n.locale}]" : k}: #{read_attribute(k).inspect}"}.join(", ")}>"
          end
        end

      end
    end
  end
end