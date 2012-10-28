module EasyAuth::Models::Identities::Password
  include EasyAuth::TokenGenerator

  def self.included(base)
    base.class_eval do
      has_secure_password

      # Attributes
      attr_accessor   :password_reset
      attr_accessible :username, :password, :password_confirmation, :remember
      alias_attribute :password_digest, :token

      # Relationships
      belongs_to :account, :polymorphic => true

      # Validations
      validates :username, :uniqueness => { :case_sensitive => false }, :presence => true
      validates :password, :presence => { :on => :create }
      validates :password, :presence => { :if => :password_reset }

      def self.authenticate(controller)
        attributes = controller.params[:identities_password]
        return nil if attributes.nil?

        if identity = where(arel_table[:username].matches(attributes[:username].try(&:strip))).first.try(:authenticate, attributes[:password])
          identity.remember = attributes[:remember]
          identity
        else
          nil
        end
      end

      def self.new_session(controller)
        controller.instance_variable_set(:@identity, self.new)
      end
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
end
