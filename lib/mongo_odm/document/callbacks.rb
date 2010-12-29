# encoding: utf-8
require 'active_support/core_ext/module/aliasing'

module MongoODM
  module Document
    module Callbacks

      extend ActiveSupport::Concern

      included do
        extend ActiveModel::Callbacks

        alias_method_chain :initialize, :callbacks
        alias_method_chain :run_callbacks, :fields

        define_model_callbacks :initialize, :only => :after
        define_model_callbacks :save, :create, :update, :destroy
      end

      module InstanceMethods
        def initialize_with_callbacks(*args)
          initialize_without_callbacks(*args)
          run_callbacks(:initialize)
          self
        end

        # execute callbacks on embedded documents, including arrays of documents.
        def run_callbacks_with_fields( kind, *args, &blk )
          run_callbacks_without_fields( kind, *args ) do
            objs = self.class.fields.keys.map { |field|  self.send(field) }
            objs.select! { |val|  val.respond_to?(:run_callbacks) || val.kind_of?(Array)  }
            if objs.present?
              Callbacks.run_multiple( objs, 0, kind, *args, &blk )
            else
              blk.call(self)
            end
          end
        end
      end

    protected
      # execute callbacks on multiple objs, including arrays.
      def self.run_multiple( objs, idx, kind, *args, &blk )
        # find next suitable object, starting at idx
        obj = nil
        while idx < objs.size  do
          obj = objs[idx]
          break  if obj.respond_to?(:run_callbacks) || obj.kind_of?(Array)
          idx += 1
        end
        return blk.call(self)  unless obj

        # warning: recursion ahead
        if obj.kind_of?(Array)
          Callbacks.run_multiple( obj, 0, kind, *args ) do
            Callbacks.run_multiple( objs, idx + 1, kind, *args, &blk )
          end
        else
          obj.run_callbacks( kind, *args )  do |obj|
            Callbacks.run_multiple( objs, idx + 1, kind, *args, &blk )
          end
        end
      end
    end
  end
end
