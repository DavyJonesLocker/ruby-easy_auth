require 'easy_auth/token_generator'

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

      # Attributes
      attr_accessor   :password
      attr_accessible :password, :password_confirmation

      # Relationships
      has_many :identities, :class_name => 'EasyAuth::Identity', :as => :account, :dependent => :destroy

      # Validations
      validates :password, :presence => { :on => :create, :if => :run_password_identity_validations? }, :confirmation => true
      validates identity_username_attribute, :presence => true, :if => :run_password_identity_validations?

      # Callbacks
      before_create :setup_password_identity, :if => :run_password_identity_validations?
      before_update :update_password_identity, :if => :run_password_identity_validations?

      def identity_username_attribute
        self.send(self.class.identity_username_attribute)
      end
    end
  end

  def password_identity
    identities.select{ |identity| EasyAuth.password_identity_model === identity }.first
  end

  def run_password_identity_validations?
    (self.new_record? && self.password.present?) || self.password_identity.present?
  end

  def generate_session_token!
    self.update_column(:session_token, _generate_token(:session))
    self.session_token
  end

  def set_session(session)
    session[:session_token] = generate_session_token!
    session[:account_class] = self.class.to_s
  end

  private

  def setup_password_identity
    self.identities << EasyAuth.password_identity_model.new(password_identity_attributes)
  end

  def update_password_identity
    self.password_identity.update_attributes(password_identity_attributes)
  end

  def password_identity_attributes
    { :username => self.identity_username_attribute, :password => self.password, :password_confirmation => self.password_confirmation }
  end
end
