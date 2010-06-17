# encoding: utf-8
module MongoODM

  class Criteria
    def initialize(collection, selector = {}, opts = {})
      @collection, @selector, @opts = collection, selector, opts
    end
    
    def find(selector = {}, opts = {})
      @selector.merge!(selector)
      @opts.merge!(opts)
      self
    end
    
    def method_missing(method_name, *args)
      @collection.find(@selector, @opts).send(method_name, *args)
    end
  end

end