module EasyAuth::Models::Account
  include EasyAuth::TokenGenerator
  extend  EasyAuth::ReverseConcern
  class   NoIdentityUsernameError < StandardError; end

  reverse_included do
    # Relationships
    has_many :identities, :class_name => 'Identity', :as => :account, :dependent => :destroy

    def identity_username_attribute
      self.send(self.class.identity_username_attribute)
    end
  end

  module ClassMethods
    # Will attempt to find the username attribute
    #
    # First will check to see if #identity_username_attribute is already defined in the model.
    #
    # If not, will check to see if `username` exists as a column on the record
    # If not, will check to see if `email` exists as a column on the record
    #
    # @returns Symbol
    def identity_username_attribute
      if respond_to?(:super)
        super
      elsif column_names.include?('username')
        :username
      elsif column_names.include?('email')
        :email
      else
        raise EasyAuth::Models::Account::NoIdentityUsernameError, 'your model must have either a #username or #email attribute. Or you must override the .identity_username_attribute class method'
      end
    end
  end

  # Generates a new session token and updates the record
  #
  # @returns String
  def generate_session_token!
    self.update_column(:session_token, _generate_token(:session))
    self.session_token
  end

  # Used to set the session for the authenticated account
  #
  # @params Rack::Session::Abstract::SessionHash
  def set_session(session)
    session[:session_token] = generate_session_token!
    session[:account_class] = self.class.to_s
  end
end
