module EasyAuth
  class Identity < ActiveRecord::Base
    belongs_to :account, :polymorphic => true
    has_secure_password
    attr_accessible :email, :password, :password_confirmation

    def self.authenticate(attributes = nil)
      return nil if attributes.nil?

      if identity = where(arel_table[:email].matches(attributes[:email].try(&:strip))).first.try(:authenticate, attributes[:password])
        identity
      else
        nil
      end
    end
  end
end
