module EasyAuth::Models::Identity
  def self.included(base)
    base.class_eval do
      belongs_to :account, :polymorphic => true
      has_secure_password
      attr_accessor   :remember_me
      attr_accessible :username, :password, :password_confirmation, :remember_me

      def self.authenticate(attributes = nil)
        return nil if attributes.nil?

        if identity = where(arel_table[:username].matches(attributes[:username].try(&:strip))).first.try(:authenticate, attributes[:password])
          identity.remember_me = attributes[:remember_me]
          identity
        else
          nil
        end
      end
    end
  end

  def password_reset
    update_attribute(:reset_token, URI.escape(_generate_token(:reset).gsub(/[\.|\\\/]/,'')))
    PasswordResetMailer.reset(self.id).deliver
  end

  def generate_session_token!
    self.update_attribute(:session_token, _generate_token(:session))
    self.session_token
  end

  def generate_remember_token!
    if remember_me
      token = _generate_token(:remember)
    else
      token = nil
    end
    self.update_attribute(:remember_token, token)
    self.remember_token
  end

  private

  def _generate_token(type)
    BCrypt::Password.create("#{id}-#{type}_token-#{DateTime.current}")
  end
end
