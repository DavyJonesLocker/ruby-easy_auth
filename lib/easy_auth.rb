require 'active_support'
require 'bcrypt'
require 'easy_auth/engine'
require 'easy_auth/version'

module EasyAuth
  extend ActiveSupport::Autoload

  autoload :Controllers
  autoload :Mailers
  autoload :Models
  autoload :ReverseConcern
  autoload :Routes
  autoload :TokenGenerator

  def self.identity_model
    ::Identity
  end

  def self.account_model
    User
  end

  def self.authenticate(controller)
    if identity_model = find_identity_model(controller.params)
      identity_model.authenticate(controller)
    end
  end

  def self.new_session(controller)
    identity_model = find_identity_model(controller.params)
    identity_model.new_session(controller)
  end

  def self.config(&block)
    yield self
  end

  def self.find_identity_model(params)
    method_name = "#{params[:identity]}_identity_model"
    camelcased_identity_name = params[:identity].to_s.camelcase
    if respond_to?(method_name)
      send(method_name, params)
    elsif eval("defined?(Identities::#{camelcased_identity_name})")
      eval("Identities::#{camelcased_identity_name}")
    else
      camelcased_identity_name.constantize
    end
  end
end

ActionDispatch::Routing::Mapper.send(:include, EasyAuth::Routes)
