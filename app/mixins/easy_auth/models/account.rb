module EasyAuth::Models::Account
  class NoIdentityUsernameError < StandardError; end
  def self.included(base)
    base.class_eval do
      unless respond_to?(:identity_username_attribute)
        def self.identity_username_attribute
          if column_names.include?('username')
            :username
          elsif column_names.include?('email')
            :email
          else
            raise EasyAuth::Models::Account::NoIdentityUsernameError, 'your model must have either a #username or #email attribute. Or you must override the .identity_username_attribute class method'
          end
        end
      end

      def identity_username_attribute
        self.send(self.class.identity_username_attribute)
      end

      has_one :identity, :as => :account
      before_create :setup_identity, :unless => :skip_identity_validations
      before_update :update_identity, :unless => :skip_identity_validations

      attr_accessor :password, :skip_identity_validations
      validates :password, :presence => { :on => :create, :unless => :skip_identity_validations }, :confirmation => true
      attr_accessible :password, :password_confirmation, :skip_identity_validations
      validates identity_username_attribute, :presence => true, :unless => :skip_identity_validations
    end
  end

  def generate_session_token!
    token = BCrypt::Password.create("#{id}-session_token-#{DateTime.current}")
    self.update_attribute(:session_token, token)
    self.session_token
  end

  def set_session(session)
    session[:session_token] = generate_session_token!
    session[:account_class] = self.class.to_s
  end

  private

  def setup_identity
    build_identity(identity_attributes)
  end

  def update_identity
    identity.update_attributes(identity_attributes)
  end

  def identity_attributes
    { :username => self.identity_username_attribute, :password => self.password, :password_confirmation => self.password_confirmation }
  end
end
