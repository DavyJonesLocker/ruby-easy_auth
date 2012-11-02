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
    if identity_model = find_identity_model(controller)
      identity_model.authenticate(controller)
    end
  end

  def self.new_session(controller)
    identity_model = find_identity_model(controller)
    identity_model.new_session(controller)
  end

  def self.config(&block)
    yield self
  end

  private

  def self.find_identity_model(controller)
    method_name = "#{controller.params[:identity]}_identity_model"
    if respond_to?(method_name)
      send(method_name, controller)
    else
      controller.params[:identity].to_s.camelcase.constantize
    end
  end
end

ActionDispatch::Routing::Mapper.send(:include, EasyAuth::Routes)
