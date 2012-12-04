module EasyAuth::Models::Identity
  include EasyAuth::ReverseConcern

  def self.included(base)
    base.class_eval do
      belongs_to :account, :polymorphic => true
      validates :username, :uniqueness => { :scope => :type }, :presence => true
      extend ClassMethods
    end
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
