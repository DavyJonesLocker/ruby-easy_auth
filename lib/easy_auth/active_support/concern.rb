module ActiveSupport::Concern
  def prepend_features(base)
    if base.instance_variable_defined?("@_dependencies")
      base.instance_variable_get("@_dependencies").unshift(self)
      return false
    else
      return false if base < self
      super
      base.extend const_get("ClassMethods") if const_defined?("ClassMethods")
      @_dependencies.each { |dep| base.send(:include, dep) }
      base.class_eval(&@_included_block) if instance_variable_defined?("@_included_block")
    end
  end

  alias_method :prepended, :included
end

