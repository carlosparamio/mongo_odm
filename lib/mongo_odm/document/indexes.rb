# encoding: utf-8

module MongoODM
  module Document
    module Indexes

      extend ActiveSupport::Concern

      class Index
        attr_reader :spec
        attr_reader :opts

        # Creates a new document index.
        # @param [String, Array] spec should be either a single field name or an array of field name, direction pairs. Directions should be specified as Mongo::ASCENDING, Mongo::DESCENDING, or Mongo::GEO2D.
        #
        # Note that geospatial indexing only works with versions of MongoDB >= 1.3.3+. Keep in mind, too, that in order to geo-index a given field, that field must reference either an array or a sub-object where the first two values represent x- and y-coordinates. Examples can be seen below.
        #
        # Also note that it is permissible to create compound indexes that include a geospatial index as long as the geospatial index comes first.
        #
        # If your code calls create_index frequently, you can use Collection#ensure_index to cache these calls and thereby prevent excessive round trips to the database.
        # @option opts [Hash] :default ({}) a customizable set of options
        def initialize(spec, opts = {})
          @spec = spec
          @opts = opts
        end
      end

      module ClassMethods
        def inherited(subclass)
          super
          indexes.concat(subclass.indexes)
        end

        def indexes
          @indexes ||= []
        end

        def index(spec, opts = {})
          new_index = Index.new(spec, opts)
          indexes << new_index
          MongoODM.add_index_class(self)
          new_index
        end
        
        def create_indexes
          indexes.each {|index| create_index index.spec, index.opts }
        end
      end

    end
  end
end
