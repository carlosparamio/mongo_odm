# encoding: utf-8
require 'active_support/core_ext/hash/indifferent_access'

module MongoODM
  module Document
    module AttributeMethods
      module Localization

        extend ActiveSupport::Concern

        included do
          attribute_method_suffix "_localized?"
          attribute_method_suffix "_localized"
          attribute_method_suffix "_localized="
          
          alias_method_chain :inspect_attribute, :localization
        end
        
        module ClassMethods
          def localized_attribute?(attr_name)
            field = fields[attr_name]
            localized = field ? !!field.options[:localized] : false
            raise MongoODM::Errors::InvalidLocalizedField.new(field.name, field.type) if localized && field && field.type != Hash
            localized
          end
          
          def define_method_attribute_localized?(attr_name)
            generated_attribute_methods.module_eval("def #{attr_name}_localized?; self.class.localized_attribute?('#{attr_name}'); end", __FILE__, __LINE__)
          end
          protected :define_method_attribute_localized?
          
          def define_method_attribute_localized(attr_name)
            if localized_attribute?(attr_name)
              generated_attribute_methods.module_eval("def #{attr_name}_localized; read_localized_attribute('#{attr_name}'); end", __FILE__, __LINE__)
            end
          end
          protected :define_method_attribute_localized
          
          def define_method_attribute_localized=(attr_name)
            if localized_attribute?(attr_name)
              generated_attribute_methods.module_eval("def #{attr_name}_localized=(new_value); write_localized_attribute('#{attr_name}', new_value); end", __FILE__, __LINE__)
            end
          end
          protected :define_method_attribute_localized=
        end

        module InstanceMethods        
          def read_localized_attribute(attr_name, locale = nil)
            locale = I18n.locale || I18n.default_locale if locale.nil?
            (read_attribute(attr_name) || {}.with_indifferent_access)[locale]
          end

          def write_localized_attribute(attr_name, value, locale = nil)
            locale = I18n.locale || I18n.default_locale if locale.nil?
            current_value = read_attribute(attr_name) || {}.with_indifferent_access
            write_attribute(attr_name, current_value.merge(locale => value))
          end
          
          def inspect_attribute_with_localization(attr_name)
            if self.class.localized_attribute?(attr_name)
              "#{attr_name}[:#{I18n.locale}]: #{read_localized_attribute(attr_name).inspect}"
            else
              inspect_attribute_without_localization(attr_name)
            end
          end
        end

      end
    end
  end
end