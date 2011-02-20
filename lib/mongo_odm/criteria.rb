# encoding: utf-8
module MongoODM

  class Criteria

    delegate :inspect, :to_xml, :to_yaml, :to_json, :include?, :to => :to_a

    def initialize(klass, selector = {}, opts = {})
      @klass, @selector, @opts = klass, selector, opts
      _set_cursor
    end
    attr_reader :selector, :opts, :cursor
    
    def ==(other)
      case other
      when Criteria
        other.instance_variable_get("@selector") == @selector &&
        other.instance_variable_get("@opts")     == @opts
      else
        to_a == other.to_a
      end
    end
    
    def to_a
      @cursor.to_a
    end
    
    def _set_cursor
      @cursor = @klass.collection.find(@selector, @opts)
    end
    
    def _merge_criteria(selector, opts)
      @selector.merge!(selector)
      @opts.merge!(opts)
      _set_cursor
      self
    end
    
    def method_missing(method_name, *args, &block)
      if @klass.respond_to?(method_name)
        result = @klass.send(method_name, *args, &block)
        result.is_a?(Criteria) ? _merge_criteria(result.selector, result.opts) : result
      elsif @cursor.respond_to?(method_name)
        @cursor.send(method_name, *args, &block)
      elsif [].respond_to?(method_name)
        to_a.send(method_name, *args, &block)
      else
        super
      end
    end

  end

end