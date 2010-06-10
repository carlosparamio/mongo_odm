# encoding: utf-8
class Shape
  include MongoODM::Document

  field :x, Float, :default => 1.0
  field :y, Float, :default => 1.0
  field :color, String
end