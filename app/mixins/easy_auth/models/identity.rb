module EasyAuth::Models::Identity
  def self.included(base)
    base.class_eval do
      belongs_to :account, :polymorphic => true
      has_secure_password
      attr_accessible :username, :password, :password_confirmation, :remember

      def self.authenticate(attributes = nil)
        return nil if attributes.nil?

        if identity = where(arel_table[:username].matches(attributes[:username].try(&:strip))).first.try(:authenticate, attributes[:password])
          identity.remember = attributes[:remember]
          identity
        else
          nil
        end
      end
    end
  end

  def remember
    @remember
  end

  def remember=(value)
    @remember = ::ActiveRecord::ConnectionAdapters::Column.value_to_boolean(value)
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
    self.update_attribute(:remember_token, _generate_token(:remember))
    self.remember_token
  end

  def remember_time
    1.year
  end

  private

  def _generate_token(type)
    BCrypt::Password.create("#{id}-#{type}_token-#{DateTime.current}")
  end
end
