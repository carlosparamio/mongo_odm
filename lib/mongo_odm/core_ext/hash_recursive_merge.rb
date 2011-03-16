class Hash
  def rmerge!(other_hash)
    merge!(other_hash) do |key, old_value, new_value| 
      old_value.class == self.class ? old_value.rmerge!(new_value) : new_value
    end
  end
  
  def rmerge(other_hash)
    result = {}
    merge(other_hash)  do |key, old_value, new_value| 
      result[key] = old_value.class == self.class ? old_value.rmerge(new_value) : new_value
    end
  end
end