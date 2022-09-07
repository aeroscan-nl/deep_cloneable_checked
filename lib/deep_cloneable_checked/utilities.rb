module DeepCloneableChecked
  def self.options_to_hash(options)
    case options
    when Hash
      options
    when Array
      options_array_to_hash(options)
    else
      options_array_to_hash([options])
    end
  end

  def self.options_array_to_hash(options)
    hash = {}
    options.each do |o|
      if o.is_a? Hash
        hash.deep_merge! o
      else
        hash[o] = []
      end
    end
    hash
  end
end