# encoding: utf-8

module MongoODM
  module Document
    module Associations

      extend ActiveSupport::Concern
      extend ActiveSupport::Autoload
      
      autoload :HasOne
      autoload :HasMany

      included do
        class_inheritable_accessor :associations
        self.associations = {}

        include MongoODM::Document::Associations::HasOne
        include MongoODM::Document::Associations::HasMany
      end
    
      module InstanceMethods
        def associations
          self.class.associations
        end
      end
    
      module ClassMethods
      end
    
    end
  end
end
