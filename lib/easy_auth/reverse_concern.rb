module EasyAuth::ReverseConcern
  def self.extended(base)
    base.instance_variable_set("@_dependencies", [])
  end

  def append_features(base)
    if base.instance_variable_defined?("@_dependencies")
      base.instance_variable_get("@_dependencies") << self
      return false
    else
      return false if base < self
      base.class_eval(&@_included_block) if instance_variable_defined?("@_included_block")
      base.extend const_get("ClassMethods") if const_defined?("ClassMethods")
      @_dependencies.each { |dep| base.send(:include, dep) }
      super
    end
  end

  def reverse_included(base = nil, &block)
    if base.nil?
      @_included_block = block
    else
      super
    end
  end
end

