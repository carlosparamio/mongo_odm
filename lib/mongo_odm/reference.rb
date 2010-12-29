# encoding: utf-8

module MongoODM
  class Reference
    include MongoODM::Document

    def initialize( attr = {} )
      if attr.kind_of?(Reference)
        @target = attr.target

      elsif attr.kind_of?(Document)
        @target = attr

      elsif attr.kind_of?(Hash)
        @target = nil
        @target_id, @path, @collection = attr.values_at( :target_id, :path, :collection )

      else
        raise "Can only reference object of type MongoODM::Document, not #{attr.class.inspect}"
      end
    end

    def target
      @target ||= MongoODM::Collection.new( MongoODM.database, @collection ).find_one(
        "#{@path}#{@path && '.'}_id" => @target_id
      )
    end

    # Object instance methods:
    #   :class, :clone, :dup, :enum_for, :instance_exec, :instance_of?, :instance_variable_defined?, :instance_variable_get,
    #   :instance_variable_set, :instance_variables, :method, :methods, :nil?, :object_id, :private_methods, :protected_methods,
    #   :public_method, :public_methods, :public_send, :respond_to_missing?, :singleton_class, :singleton_methods, :taint,
    #   :tainted?, :tap, :to_enum, :trust, :untaint, :untrust, :untrusted?, :equal?

    delegate :!=, :!~, :<=>, :==, :===, :=~, :eql?, :to => :target
    #delegate :inspect, :to_s, :instance_eval, :hash, :is_a?, :kind_of?, :respond_to?, :to => :target
    delegate :__send__, :send, :to => :target
    def method_missing( method, *args )
      target.send method, *args
    end

    def to_mongo
      if @target
        @collection ||= @target.class.collection.name
        @target_id ||= @target.id
        raise "Cannot serialize reference to unsaved document: #{@target.inspect}"  unless @collection && @target_id
      end
      { '_class' => self.class.name, 'collection' => @collection, 'target_id' => @target_id }
    end

    def self.type_cast( value )
      return nil if value.nil?
      return value if value.is_a?(Reference)
      Reference.new value
    end
  end
end