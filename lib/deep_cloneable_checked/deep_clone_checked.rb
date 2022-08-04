module DeepCloneableChecked
  module DeepCloneChecked
    def deep_clone_checked(options)
      if options[:include].is_a?(Hash) || options[:include].is_a?(Symbol)
        options[:include] = [options[:include]]
      end
  
      if options[:exclude].is_a?(Hash) || options[:exclude].is_a?(Symbol)
        options[:exclude] = [options[:exclude]]
      end
  
      missing = validate_clone_check(options)
      
      unless missing.empty?
        raise MissingAssociationError, "Not all associations cloned: #{missing.inspect}"
      end
  
      deep_clone(options)
    end
  
    def validate_clone_check(options)
      find_symbol_or_hash = lambda do |options, association_name|
        
        result = options.find do |option|
          if option.is_a? Symbol
            option.to_s == association_name
          elsif option.is_a? Hash
            option[association_name.to_sym]
          else
            nil
          end
        end
        result
      end
  
      check_missing = lambda do |klass, includes, excludes|
        # puts "-----------\n klass: #{klass.name}, includes: #{includes.inspect}, excludes: #{excludes.inspect}"
        associations = klass.reflections
  
        associations.map do |association_name, reflection|
  
          to_exclude = find_symbol_or_hash[excludes, association_name]
          if to_exclude.is_a? Symbol
            next_excludes = []
          elsif to_exclude.is_a? Array
            next_excludes = to_exclude
          elsif to_exclude.nil?
            next_excludes = []
          else
            next_excludes = to_exclude[association_name.to_sym]
          end
  
          inclusion = find_symbol_or_hash[includes, association_name]
  
          if inclusion.is_a? Symbol
            # puts "inclusion: #{inclusion.inspect}, association_name: #{association_name}" 
            result = check_missing[reflection.klass, [], next_excludes]
            if !result.blank?
              # puts "missing from #{reflection.klass.name}, #{association_name}"
              Hash[association_name.to_sym, result]
            end
          elsif inclusion.is_a? Hash
            # puts "inclusion: #{inclusion.inspect}, association_name: #{association_name}"
            result = check_missing[reflection.klass, [inclusion[association_name.to_sym]], next_excludes]
            if !result.blank?
              # puts "missing from #{reflection.klass.name}, #{association_name}"
              Hash[association_name.to_sym, result]
            end
          else
            # puts "No inclusion for #{association_name}, inclusion: #{inclusion.inspect}, to_exclude: #{to_exclude.inspect}"
            if to_exclude.is_a? Symbol
              nil
            else
              # puts "No exclusion either"
              association_name.to_sym
            end
          end
        end.compact
      end
  
      check_missing[self.class, options[:include] || [], options[:exclude] || []]
    end
  end
end