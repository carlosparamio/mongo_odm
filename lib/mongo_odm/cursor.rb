# encoding: utf-8
module MongoODM

  delegate :inspect, :to_xml, :to_yaml, :to_json, :include?, :to => :to_a

  class Cursor < Mongo::Cursor  
    def next_document
      doc = super
      MongoODM.instanciate(doc)
    end
  end

end