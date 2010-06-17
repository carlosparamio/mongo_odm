# encoding: utf-8

module MongoODM
  module Document
    module AttributeMethods
      module Inspect

        extend ActiveSupport::Concern
        
        module InstanceMethods
          def inspect_attribute(attr_name)
            "#{attr_name}: #{read_attribute(attr_name).inspect}"
          end
        end

      end
    end
  end
end
