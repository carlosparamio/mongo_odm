# encoding: utf-8
module MongoODM

  class Criteria
    def initialize(klass, selector = {}, opts = {})
      @klass, @selector, @opts = klass, selector, opts
    end
    
    def find(selector = {}, opts = {})
      _merge_criteria(selector, opts)
    end
    
    def method_missing(method_name, *args)
      if @klass.methods.include?(method_name)
        result = @klass.send(method_name, *args)
        if result.is_a?(Criteria)
          selector = result.instance_variable_get("@selector")
          opts = result.instance_variable_get("@opts")
          _merge_criteria(selector, opts)
        else
          result
        end
      else
        @klass.collection.find(@selector, @opts).send(method_name, *args)
      end
    end
    
    def _merge_criteria(selector, opts)
      @selector.merge!(selector)
      @opts.merge!(opts)
      self
    end
  end

end