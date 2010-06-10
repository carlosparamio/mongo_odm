# encoding: utf-8
class Circle < Shape
  include MongoODM::Document

  set_collection :shapes
  field :radius, Float, :default => 1.0
end