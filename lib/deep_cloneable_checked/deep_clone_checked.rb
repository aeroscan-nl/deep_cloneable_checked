require 'set'

module DeepCloneableChecked
  module DeepCloneChecked
    def deep_clone_checked(options)
      missing = validate_clone_check(options)
      
      unless missing.empty?
        raise MissingAssociationError, "Not all associations cloned: #{missing.inspect}"
      end
  
      deep_clone(options)
    end
  
    def validate_clone_check(options)
      checked = Set[]

      check_missing = lambda do |klass, includes, excludes|
        includes = DeepCloneableChecked.options_to_hash(includes)
        excludes = DeepCloneableChecked.options_to_hash(excludes)
        # puts "-----------\n klass: #{klass.name}, includes: #{includes.inspect}, excludes: #{excludes.inspect}"

        # If we have already checked this class then we assume we don't
        # clone it in a different manner. This assumption might not be valid
        # but assuming otherwise would be complex and YAGNI (hopefully).
        return nil if checked.include? klass

        checked << klass
        associations = klass.reflections

        associations.map do |association_name, reflection|
          next nil if reflection.is_a? ActiveRecord::Reflection::ThroughReflection
          next_excludes = excludes[association_name.to_sym]
          next_includes = includes[association_name.to_sym]
  
          if next_includes
            # puts "inclusion: #{inclusion.inspect}, association_name: #{association_name}"
            result = check_missing[reflection.klass, next_includes, next_excludes]
            if !result.blank?
              # puts "missing from #{reflection.klass.name}, #{association_name}"
              Hash[association_name.to_sym, result]
            end
          else
            # puts "No inclusion for #{association_name}, inclusion: #{inclusion.inspect}, to_exclude: #{to_exclude.inspect}"
            if next_excludes
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