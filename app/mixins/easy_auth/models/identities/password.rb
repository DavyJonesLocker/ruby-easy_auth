module EasyAuth::Models::Identities::Password
  def self.included(base)
    base.class_eval do
      belongs_to :account, :polymorphic => true
      has_secure_password
      attr_accessor :password_reset
      attr_accessible :username, :password, :password_confirmation, :remember
      validates :username, :uniqueness => { :case_sensitive => false }, :presence => true
      validates :password, :presence => { :on => :create }
      validates :password, :presence => { :if => :password_reset }
      alias_attribute :password_digest, :token
      extend ClassMethods
    end
  end

  module ClassMethods
    def authenticate(controller)
      attributes = controller.params[:password_identity]
      return nil if attributes.nil?

      if identity = where(arel_table[:username].matches(attributes[:username].try(&:strip))).first.try(:authenticate, attributes[:password])
        identity.remember = attributes[:remember]
        identity
      else
        nil
      end
    end

    def new_session(controller)
      controller.instance_variable_set(:@identity, self.new)
    end
  end

  def set_account_session(session)
    account.set_session(session)
  end

  def remember
    @remember
  end

  def remember=(value)
    @remember = ::ActiveRecord::ConnectionAdapters::Column.value_to_boolean(value)
  end

  def generate_reset_token!
    update_column(:reset_token, URI.escape(_generate_token(:reset).gsub(/[\.|\\\/]/,'')))
    reset_token
  end

  def generate_remember_token!
    update_column(:remember_token, _generate_token(:remember))
    remember_token
  end

  def remember_time
    1.year
  end

  private

  def _generate_token(type)
    token = BCrypt::Password.create("#{id}-#{type}_token-#{DateTime.current}")
  end
end
