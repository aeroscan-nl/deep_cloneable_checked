require "deep_cloneable_checked/version"
require 'deep_cloneable'
require 'deep_cloneable_checked/utilities'
require 'deep_cloneable_checked/deep_clone_checked'

module DeepCloneableChecked
  class MissingAssociationError < StandardError; end
end

if defined?(ActiveSupport)
  ActiveSupport.on_load :active_record do
    include DeepCloneableChecked::DeepCloneChecked
  end
end
