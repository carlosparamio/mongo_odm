# encoding: utf-8
class Circle < Shape
  include MongoODM::Document

  field :radius, Float, :default => 1.0
end