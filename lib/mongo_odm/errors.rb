# encoding: utf-8
module MongoODM

  module Errors
    class TypeCastMissing < StandardError
      def initialize(value, klass)
        super "can't convert #{value.inspect} to #{klass}: Define a `type_cast' method for #{value.class}:#{value.class.class}"
      end
    end
    
    class InvalidLocalizedField < StandardError
      def initialize(field_name, klass)
        super "can't localize field #{field_name}; it has to be declared as a Hash, was #{klass}"
      end
    end

    class DocumentNotFound < StandardError
      def initialize(ids, klass)
        super "can't find document for class #{klass} with id(s) #{ids}"
      end
    end
  end

end