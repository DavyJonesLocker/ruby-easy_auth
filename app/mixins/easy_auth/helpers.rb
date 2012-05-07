module EasyAuth
  module Helpers
    def self.included(base)
      base.class_eval do
        helper_method :current_account, :current_user, :account_signed_in?, :user_signed_in?, :account_not_signed_in?, :user_not_signed_in?
      end
    end

    def current_account
      if session[:session_token]
        begin
          @current_account ||= EasyAuth.identity_model.find_by_session_token(session[:session_token]).account
        rescue
          @current_account = nil
          session.delete(:session_token)
        end
      end

      @current_account
    end
    alias :current_user :current_account

    def account_signed_in?
      current_account
    end
    alias :user_signed_in? :account_signed_in?

    def account_not_signed_in?
      !account_signed_in?
    end
    alias :user_not_signed_in? :account_not_signed_in?

  end
end
