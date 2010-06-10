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
class Mongo::ObjectID
  def self.type_cast(value)
    return nil if value.nil?
    return value if value.is_a?(Mongo::ObjectID)
    value.to_s
  end
  
  def to_mongo
    self
  end
end

# @private
class BSON::ObjectID
  def self.type_cast(value)
    return nil if value.nil?
    return value if value.is_a?(BSON::ObjectID)
    value.to_s
  end
  
  def to_mongo
    self
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
    return nil if value.nil?
    value.to_s.intern
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
    return nil if value.nil?
    value.to_s
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
module Boolean
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