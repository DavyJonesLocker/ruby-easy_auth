module EasyAuth
  class Identity < ActiveRecord::Base
    belongs_to :account, :polymorphic => true
    has_secure_password
    attr_accessible :username, :password, :password_confirmation

    def self.authenticate(attributes = nil)
      return nil if attributes.nil?

      if identity = where(arel_table[:username].matches(attributes[:username].try(&:strip))).first.try(:authenticate, attributes[:password])
        identity
      else
        nil
      end
    end

    def password_reset
      update_attribute(:reset_token, _generate_token(:reset))
      PasswordResetMailer.reset(self.id).deliver
    end

    def generate_session_token!
      self.update_attribute(:session_token, _generate_token(:session))
      self.session_token
    end

    private

    def _generate_token(type)
      Digest::SHA1.hexdigest("#{id}-#{type}_token-#{DateTime.current}")
    end
  end
end
