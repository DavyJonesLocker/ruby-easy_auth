module EasyAuth
  module Account
    def self.included(base)
      base.class_eval do
        unless respond_to?(:easy_auth_username)
          def self.easy_auth_username
            :username
          end
        end

        def easy_auth_username
          self.send(self.class.easy_auth_username)
        end

        has_one :identity, :class_name => 'EasyAuth::Identity', :as => :account
        before_create :setup_identity
        before_update :update_identity

        attr_accessor :password
        validates :password, :presence => { :on => :create }, :confirmation => true
        attr_accessible :password, :password_confirmation
        validates easy_auth_username, :presence => true
      end
    end

    private

    def setup_identity
      build_identity(identity_attributes)
    end

    def update_identity
      identity.update_attributes(identity_attributes)
    end

    def identity_attributes
      { :username => self.easy_auth_username, :password => self.password, :password_confirmation => self.password_confirmation }
    end
  end
end
