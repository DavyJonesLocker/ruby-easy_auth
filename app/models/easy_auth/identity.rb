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
      update_attribute(:reset_token, _generate_reset_token)
      PasswordResetMailer.reset(self.id).deliver
    end

    private

    def _generate_reset_token
      Digest::SHA1.hexdigest("#{id}-password_reset-#{DateTime.current}")
    end
  end
end
