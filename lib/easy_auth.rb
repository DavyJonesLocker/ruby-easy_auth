require 'active_support'
require 'easy_auth/engine'
require 'easy_auth/version'
require 'easy_auth/active_support/concern'

module EasyAuth
  extend ActiveSupport::Autoload

  autoload :Controllers
  autoload :Helpers
  autoload :Mailers
  autoload :Models
  autoload :Routes
  autoload :TokenGenerator

  # The top-level model that should be inherited from to build EasyAuth identities
  #
  # @return [Class]
  def self.identity_model
    ::Identity
  end

  # The assumed account class
  #
  # @return [Class]
  def self.account_model
    User
  end

  # Main authenticate method to delegate to the proper identity's .authenticate method
  # Should handle any redirects necessary
  #
  # @param [ActionController::Base] controller instance of the controller
  def self.authenticate(controller)
    if identity_model = find_identity_model(controller.params)
      identity_model.authenticate(controller)
    end
  end

  # Main new_session method to delegate to the proper identity's .new_session method
  # Should handle any redirects necessary
  #
  # @param [ActionController::Base] controller instance of the controller
  def self.new_session(controller)
    identity_model = find_identity_model(controller.params)
    identity_model.new_session(controller)
  end

  # EasyAuth config
  #
  # @param [&block] block
  def self.config(&block)
    yield self
  end

  # Find the proper identity model
  # Will use params[:identity] to first see if the identity's model method exists:
  #
  # i.e. password_identity_model
  #
  # If that method doesn't exist, will see if `Identities::#{camelcased_identity_name}` is defined
  #
  # If that fails will finally check to see if the camelcased identity name exists in the top-leve namespace
  #
  # @param [Hash] params must contain an `identity` key
  # @return [Class]
  def self.find_identity_model(params)
    method_name = "#{params[:identity]}_identity_model"
    camelcased_identity_name = params[:identity].to_s.camelcase
    if respond_to?(method_name)
      send(method_name, params)
    elsif eval("::Identities::#{camelcased_identity_name} rescue nil")
      eval("::Identities::#{camelcased_identity_name}")
    else
      camelcased_identity_name.constantize
    end
  end
end

ActionDispatch::Routing::Mapper.send(:include, EasyAuth::Routes)
