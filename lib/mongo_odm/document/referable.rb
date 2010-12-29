# encoding: utf-8

module MongoODM
  autoload :Reference

  module Document
    module Referable
      extend ActiveSupport::Concern

      module InstanceMethods
        Reference = MongoODM::Reference

        def reference
          Reference.new self
        end
      end
    end
  end
end
