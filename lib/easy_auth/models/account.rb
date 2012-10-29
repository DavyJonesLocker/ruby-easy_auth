module EasyAuth::Models::Account
  include EasyAuth::TokenGenerator
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

      # Relationships
      has_many :identities, :class_name => 'EasyAuth::Identity', :as => :account, :dependent => :destroy

      def identity_username_attribute
        self.send(self.class.identity_username_attribute)
      end
    end
  end

  def generate_session_token!
    self.update_column(:session_token, _generate_token(:session))
    self.session_token
  end

  def set_session(session)
    session[:session_token] = generate_session_token!
    session[:account_class] = self.class.to_s
  end
end
