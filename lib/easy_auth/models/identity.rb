module EasyAuth::Models::Identity
  include EasyAuth::TokenGenerator
  include EasyAuth::ReverseConcern

  def self.included(base)
    base.class_eval do
      belongs_to :account, :polymorphic => true
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

  # Sets the session for the association account
  #
  # @param [Rack::Session::Abstract::SessionHash] session controller session
  def set_account_session(session)
    account.set_session(session)
  end

  # Getter for the remember flag
  def remember
    @remember
  end

  # Setter for the remember flag
  #
  # @param [Boolean] value
  def remember=(value)
    @remember = ::ActiveRecord::ConnectionAdapters::Column.value_to_boolean(value)
  end

  # Generates a new remember token and updates it on the identity record
  #
  # @return [String]
  def generate_remember_token!
    update_column(:remember_token, _generate_token(:remember))
    remember_token
  end

  # The time used for remembering how long to stay signed in
  #
  # Defaults to 1 year, override in the model to set your own custom remember time
  #
  # @return [DateTime]
  def remember_time
    1.year
  end
end
