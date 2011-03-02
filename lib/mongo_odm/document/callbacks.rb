# encoding: utf-8
require 'active_support/core_ext/module/aliasing'

module MongoODM
  module Document
    module Callbacks

      extend ActiveSupport::Concern

      included do
        extend ActiveModel::Callbacks

        alias_method_chain :initialize, :callbacks

        define_model_callbacks :initialize, :only => :after
        define_model_callbacks :save, :destroy
        define_model_callbacks :validate, :only => :before
      end

      module InstanceMethods
        def initialize_with_callbacks(*args)
          initialize_without_callbacks(*args)
          run_callbacks(:initialize)
          self
        end
      end

    end
  end
end
