# encoding: utf-8
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require "rubygems"
require "rspec"
require "mongo_odm"

# Load all example models
MODELS_PATH = File.join(File.dirname(__FILE__), "models")
Dir[ File.join(MODELS_PATH, "*.rb") ].sort.each { |file| require file }