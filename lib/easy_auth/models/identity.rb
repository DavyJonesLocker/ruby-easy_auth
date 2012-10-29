module EasyAuth::Models::Identity
  def self.included(base)
    base.class_eval do
      belongs_to :account, :polymorphic => true
      extend ClassMethods
    end
  end

  module ClassMethods
    def authenticate(attributes = nil)
      raise NotImplementedError
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
