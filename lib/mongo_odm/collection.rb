# encoding: utf-8
module MongoODM

  class Collection < Mongo::Collection
    def find(selector={}, opts={})
      fields = opts.delete(:fields)
      fields = ["_id"] if fields && fields.empty?
      skip   = opts.delete(:skip) || skip || 0
      limit  = opts.delete(:limit) || 0
      sort   = opts.delete(:sort)
      hint   = opts.delete(:hint)
      snapshot = opts.delete(:snapshot)
      batch_size = opts.delete(:batch_size)
      if opts[:timeout] == false && !block_given?
        raise ArgumentError, "Timeout can be set to false only when #find is invoked with a block."
      end
      timeout = block_given? ? (opts.delete(:timeout) || true) : true
      if hint
        hint = normalize_hint_fields(hint)
      else
        hint = @hint        # assumed to be normalized already
      end
      raise RuntimeError, "Unknown options [#{opts.inspect}]" unless opts.empty?

      cursor = MongoODM::Cursor.new(self, :selector => selector, :fields => fields, :skip => skip, :limit => limit,
                          :order => sort, :hint => hint, :snapshot => snapshot, :timeout => timeout, :batch_size => batch_size)
      if block_given?
        yield cursor
        cursor.close()
        nil
      else
        cursor
      end
    end
    
    def insert(doc_or_docs, options={})
      doc_or_docs = [doc_or_docs] unless doc_or_docs.is_a?(Array)
      super doc_or_docs.map{|doc| doc.respond_to?(:to_mongo) ? doc.to_mongo : doc}
    end
  end

end