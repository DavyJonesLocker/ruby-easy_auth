module ActiveSupport::Concern
  def append_features(base)
    if base.instance_variable_defined?("@_dependencies")
      base.instance_variable_get("@_dependencies") << { :method => :include, :module => self }
      return false
    else
      return false if base < self
      @_dependencies.each { |dep| Hash === dep ? base.send(dep[:method], dep[:module]) : base.send(:include, dep) }
      super
      base.extend const_get("ClassMethods") if const_defined?("ClassMethods")
      base.class_eval(&@_included_block) if instance_variable_defined?("@_included_block")
    end
  end

  def prepend_features(base)
    if base.instance_variable_defined?("@_dependencies")
      base.instance_variable_get("@_dependencies").unshift({ :method => :prepend, :module => self })
      return false
    else
      return false if base < self
      super
      base.singleton_class.send(:prepend, const_get("ClassMethods")) if const_defined?("ClassMethods")
      @_dependencies.each { |dep| Hash === dep ? base.send(dep[:method], dep[:module]) : base.send(:prepend, dep) }
      base.class_eval(&@_prepended_block) if instance_variable_defined?("@_prepended_block")
    end
  end

  def prepended(base = nil, &block)
    if base.nil?
      raise MultipleIncludedBlocks if instance_variable_defined?("@_prepended_block")

      @_prepended_block = block
    else
      super
    end
  end
end
