module EasyAuth
  module Account
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
              raise EasyAuth::Account::NoIdentityUsernameError, 'your model must have either a #username or #email attribute. Or you must override the .identity_username_attribute class method'
            end
          end
        end

        def identity_username_attribute
          self.send(self.class.identity_username_attribute)
        end

        has_one :identity, :class_name => 'EasyAuth::Identity', :as => :account
        before_create :setup_identity
        before_update :update_identity

        attr_accessor :password
        validates :password, :presence => { :on => :create }, :confirmation => true
        attr_accessible :password, :password_confirmation
        validates identity_username_attribute, :presence => true
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
      { :username => self.identity_username_attribute, :password => self.password, :password_confirmation => self.password_confirmation }
    end
  end
end
