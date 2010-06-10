# encoding: utf-8
class BigRedCircle < Circle
  include MongoODM::Document
  
  set_collection :shapes
  field :radius, Float, :default => 20.0
  field :color, String, :default => "red"
end