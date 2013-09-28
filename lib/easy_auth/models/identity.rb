require 'postgres_ext'
require 'easy_auth/active_record/validations/array_uniqueness'

module EasyAuth::Models::Identity
  extend ActiveSupport::Concern

  included do
    belongs_to :account, :polymorphic => true
    validates :uid, :array_uniqueness => { :scope => :type, array: true }, :presence => true
  end

  module ClassMethods
    # Base authentication method, should be implemented by child identities
    #
    # @param [ActionController::Base] controller instance of the controller
    def authenticate(controller = nil)
      raise NotImplementedError
    end

    # Base assumption for new sessions on the controller, will set `@identity` to a new instance of the identity
    #
    # @param [ActionController::Base] controller instance of the controller
    def new_session(controller)
      controller.instance_variable_set(:@identity, self.new)
    end
  end
end
