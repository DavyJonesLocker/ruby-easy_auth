module EasyAuth::Models::Identity
  extend ActiveSupport::Concern

  included do
    belongs_to :account, polymorphic: true, dependent: :destroy
    validates :uid, :uniqueness => { :scope => :type }, :presence => true
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
