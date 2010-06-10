# encoding: utf-8

module MongoODM
  module Document
    module AttributeMethods
      module Read

        extend ActiveSupport::Concern
        
        included do
          attribute_method_suffix ""
        end

        module ClassMethods
          def define_method_attribute(attr_name)
            generated_attribute_methods.module_eval("def #{attr_name}; read_attribute('#{attr_name}'); end", __FILE__, __LINE__)
          end
          protected :define_method_attribute
        end

        module InstanceMethods
          def read_attribute(attr_name)
            @attributes[attr_name]
          end
          
          def [](attr_name)
            read_attribute[attr_name]
          end

          def attribute(attr_name)
            read_attribute(attr_name)
          end
          private :attribute
        end

      end
    end
  end
end
