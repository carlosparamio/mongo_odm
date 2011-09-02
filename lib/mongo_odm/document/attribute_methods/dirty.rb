# encoding: utf-8
require 'active_support/core_ext/module/aliasing'

module MongoODM
  module Document
    module AttributeMethods
      module Dirty

        extend ActiveSupport::Concern

        included do
          include ActiveModel::Dirty

          alias_method_chain :initialize, :dirty
          alias_method_chain :write_attribute, :dirty
          alias_method_chain :save, :dirty
          alias_method_chain :reload, :dirty
        end

        module InstanceMethods
          def initialize_with_dirty(*args)
            initialize_without_dirty(*args)
            changed_attributes.clear
            self
          end

          def write_attribute_with_dirty(attr_name, value)
            if respond_to?("#{attr_name}_will_change!") && (read_attribute(attr_name) != value)
              send("#{attr_name}_will_change!")
            end
            write_attribute_without_dirty(attr_name, value)
          end

          def save_with_dirty(*args)
            if status = save_without_dirty(*args)
              @previously_changed = changes
              changed_attributes.clear
            end
            status
          end

          def reload_with_dirty(*args)
            reload_without_dirty(*args).tap do
              @previously_changed = nil
              changed_attributes.clear
            end
          end
        end

      end
    end
  end
end
