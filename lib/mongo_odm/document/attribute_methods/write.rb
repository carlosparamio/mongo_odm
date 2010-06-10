# encoding: utf-8

module MongoODM
  module Document
    module AttributeMethods
      module Write

        extend ActiveSupport::Concern
        
        included do
          attribute_method_suffix "="
        end

        module ClassMethods
          def define_method_attribute=(attr_name)
            generated_attribute_methods.module_eval("def #{attr_name}=(new_value); write_attribute('#{attr_name}', new_value); end", __FILE__, __LINE__)
          end
          protected :define_method_attribute=
        end

        module InstanceMethods          
          def write_attribute(attr_name, value)
            field = self.class.fields[attr_name]
            type = field ? field.type : value.class
            @attributes[attr_name] = attr_name.to_sym == :_id ? value : type.type_cast(value)
          end

          def attribute=(attr_name, value)
            write_attribute(attr_name, value)
          end
          private :attribute=
        end

      end
    end
  end
end
