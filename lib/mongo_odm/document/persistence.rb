# encoding: utf-8
require 'active_support/core_ext/string/inflections'
require 'forwardable'

module MongoODM
  module Document
    module Persistence
      
      extend ActiveSupport::Concern

      module InstanceMethods
        def id
          attributes[:_id]
        end

        def new_record?
          id.nil?
        end
      
        def reload
          self.load_attributes_or_defaults(self.class.find_one(:_id => id).attributes) unless new_record?
        end
      
        # Save a document to its collection.
        #
        # @return [ObjectID] the _id of the saved document.
        #
        # @option opts [Boolean] :safe (+false+) 
        #   If true, check that the save succeeded. OperationFailure
        #   will be raised on an error. Note that a safe check requires an extra
        #   round-trip to the database.
        def save(options = {})
          _run_save_callbacks do
            write_attribute(:_id, self.class.save(to_mongo, options))
          end
        end
      
        def update_attributes(attributes)
          self.attributes = attributes
          save
        end
        
        def destroy
          return false if new_record?
          _run_destroy_callbacks do
            self.class.remove({ :_id => self.id })
          end
        end
      
        def to_mongo
          attributes.inject({}.with_indifferent_access) do |attrs, (key, value)|
            attrs[key] = value.to_mongo unless value.nil? # self.class.fields[key].default == value
            attrs
          end
        end
      end
    
      module ClassMethods
        def collection
          @collection ||= if self.superclass.included_modules.include?(MongoODM::Document)
                            self.superclass.collection
                          else
                            MongoODM::Collection.new(MongoODM.database, name.tableize)
                          end
        end
      
        def set_collection(name_or_collection)
          @collection = case name_or_collection
                        when MongoODM::Collection
                          name_or_collection
                        when String, Symbol
                          MongoODM::Collection.new(MongoODM.database, name_or_collection)
                        else
                          raise "MongoODM::Collection instance or valid collection name required"
                        end
        end
        
        def find(*args)
          MongoODM::Criteria.new(collection, *args)
        end
        
        def destroy_all(*args)
          documents = find(*args)
          count = documents.count
          documents.each { |doc| doc.destroy }
          count
        end
      
        def type_cast(value)
          return nil if value.nil?
          return value if value.class == self
          new(value)
        end

        extend Forwardable
        def_delegators :collection, :db, :hint, :hint=, :pk_factory, :[], :count, :create_index, :distinct,
                       :drop, :drop_index, :drop_indexes, :find_and_modify, :find_one, :group,
                       :index_information, :insert, :<<, :map_reduce, :mapreduce, :options, :remove, :rename,
                       :save, :stats, :update
      end

    end
  end
end