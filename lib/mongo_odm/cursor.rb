# encoding: utf-8
module MongoODM

  class Cursor < Mongo::Cursor  
    def next_document
      doc = super
      MongoODM.instanciate(doc)
    end
  end

end