module EasyAuth::Models::Identity
  include EasyAuth::TokenGenerator
  include EasyAuth::ReverseConcern

  def self.included(base)
    base.class_eval do
      belongs_to :account, :polymorphic => true
      extend ClassMethods
    end
  end

  module ClassMethods
    def authenticate(controller = nil)
      raise NotImplementedError
    end

    def new_session(controller)
      controller.instance_variable_set(:@identity, self.new)
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
end
