module EasyAuth
  module Account
    def self.included(base)
      base.class_eval do
        has_one :identity, :class_name => 'EasyAuth::Identity', :as => :account
        before_create :setup_identity

        attr_accessor :password
        validates :password, :presence => { :on => :create }, :confirmation => true
        validates :email, :presence => true
      end
    end

    def setup_identity
      build_identity(:email => self.email, :password => self.password, :password_confirmation => self.password_confirmation)
    end
  end
end
