# encoding: utf-8
require 'active_support/core_ext/big_decimal'
require 'active_support/core_ext/date/conversions'
require 'active_support/core_ext/date_time/calculations'
require 'active_support/core_ext/date_time/conversions'
require 'active_support/core_ext/string/conversions'
require 'active_support/core_ext/time/conversions'

# The type_cast class method is called when:
#  * An attribute of the same class is assigned
#  * An attribute of the same class is readed from the Mongo driver
#
# The to_mongo instance method is called when:
#  * An attribute of the same class is sent to the Mongo driver

# @private
class BSON::ObjectId
  def self.type_cast(value)
    return nil if value.nil?
    return value if value.is_a?(BSON::ObjectId)
    BSON::ObjectId(value)
  end
  
  def to_mongo
    self
  end
end

# @private
class BSON::DBRef
  def self.type_cast(value)
    return value if value.is_a?(BSON::DBRef)
    return value.to_dbref if value.respond_to?(:to_dbref)
    nil
  end
  
  def to_mongo
    self
  end
  
  def dereference
    MongoODM.instanciate(MongoODM.database.dereference(self))
  end
  
  def inspect
    "BSON::DBRef(namespace:\"#{namespace}\", id: \"#{object_id}\")"
  end
end

# @private
class Array
  def self.type_cast(value)
    return nil if value.nil?
    value.to_a.map {|elem| MongoODM.instanciate(elem)}
  end
  
  def to_mongo
    self.map {|elem| elem.to_mongo}
  end
  
  def dereference
    MongoODM.instanciate(self.map{|value| MongoODM.dereference(value)})
  end
end

# @private
class Class
  def self.type_cast(value)
    return nil if value.nil?
    value.to_s.constantize
  end
  
  def to_mongo
    self.name
  end
end

# @private
class Symbol
  def self.type_cast(value)
    case value
      when nil then nil
      when Symbol then value
      when String then value.intern
      else value.inspect.intern
    end
  end
  
  def to_mongo
    self
  end
end

# @private
class Integer
  def self.type_cast(value)
    return nil if value.nil?
    value.to_i
  end
  
  def to_mongo
    self
  end
end

# @private
class Float
  def self.type_cast(value)
    return nil if value.nil?
    value.to_f
  end
  
  def to_mongo
    self
  end
end

# @private
class BigDecimal
  def self.type_cast(value)
    return nil if value.nil?
    value.is_a?(BigDecimal) ? value : new(value.to_s)
  end
  
  def to_mongo
    self.to_s
  end
end

# @private
class String
  def self.type_cast(value)
    case value
      when nil then nil
      when String, Symbol then value.to_s
      else value.inspect
    end
  end
  
  def to_mongo
    self
  end
end

# @private
class Date
  def self.type_cast(value)
    return nil if value.nil?
    value.to_date
  end
  
  def to_mongo
    Time.utc(self.year, self.month, self.day)
  end
end

# @private
class DateTime
  def self.type_cast(value)
    return nil if value.nil?
    value.to_datetime
  end
  
  def to_mongo
    datetime = self.utc
    Time.utc(datetime.year, datetime.month, datetime.day, datetime.hour, datetime.min, datetime.sec)
  end
end

# @private
class TrueClass
  def self.type_cast(value)
    return nil if value.nil?
    true
  end

  def to_mongo
    self
  end
end

# @private
class FalseClass
  def self.type_cast(value)
    return nil if value.nil?
    false
  end
  
  def to_mongo
    self
  end
end

# @private
class Time
  def self.type_cast(value)
    return nil if value.nil?
    value.to_time
  end
  
  def to_mongo
    self.utc
  end
end

# Stand-in for true/false property types.
# @private
class Boolean
  def self.type_cast(value)
    case value
    when NilClass
      nil
    when Numeric
      !value.zero?
    when TrueClass, FalseClass
      value
    when /^\s*t/i
      true
    when /^\s*f/i
      false
    else
      value.present?
    end
  end
end

# @private
class Numeric
  def self.type_cast(value)
    return nil if value.nil?
    float_value = value.to_f
    int_value = value.to_i
    float_value == int_value ? int_value : float_value
  end
end

# @private
class Hash
  def self.type_cast(value)
    return nil if value.nil?
    Hash[value.to_hash.map{|k,v| [MongoODM.instanciate(k), MongoODM.instanciate(v)]}]
  end
  
  def to_mongo
    Hash[self.map{|k,v| [k.to_mongo, v.to_mongo]}]
  end
  
  def dereference
    Hash[self.map{|k,v| [MongoODM.instanciate(MongoODM.dereference(k)), MongoODM.instanciate(MongoODM.dereference(v))]}]
  end
end

# @private
class HashWithIndifferentAccess
  def self.type_cast(value)
    Hash.type_cast(value).with_indifferent_access
  end
  
  def to_mongo
    Hash[self.map{|k,v| [k.to_mongo, v.to_mongo]}]
  end
end

# @private
class Regexp
  def self.type_cast(value)
    return nil if value.nil?
    new(value)
  end
  
  def to_mongo
    self
  end
end

# @private
class NilClass
  def self.type_cast(value)
    nil
  end
  
  def to_mongo
    nil
  end
end