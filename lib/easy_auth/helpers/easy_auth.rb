module EasyAuth::Helpers::EasyAuth
  extend ActiveSupport::Concern

  def self.included(base)
    base.class_eval do
      def self.included(base)
        base.class_eval do
          helper_method :current_account, :current_user, :account_signed_in?, :user_signed_in?, :account_not_signed_in?, :user_not_signed_in?
        end
      end
    end
  end

  # Access the current account the users is authenticated with
  #
  # @return [Account] instance
  def current_account
    if session[:identity_id]
      begin
        @current_account ||= EasyAuth.identity_model.find(session[:identity_id]).account
      rescue ActiveRecord::RecordNotFound
        @current_account = nil
        delete_session_data
      end
    end

    @current_account
  end
  alias :current_user :current_account

  # Should be used to test if user is authenticated
  def account_signed_in?
    current_account
  end
  alias :user_signed_in? :account_signed_in?

  # Should be used to test if user is not authenticated
  def account_not_signed_in?
    !account_signed_in?
  end
  alias :user_not_signed_in? :account_not_signed_in?

  private

  def delete_session_data
    session.delete(:identity_id)
  end
end
