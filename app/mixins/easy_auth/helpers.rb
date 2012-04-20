module EasyAuth
  module Helpers
    def self.included(base)
      base.class_eval do
        helper_method :current_account, :current_user, :account_signed_in?, :user_signed_in?, :account_not_signed_in?, :user_not_signed_in?
      end
    end

    def current_account
      if session[:identity_id]
        @current_account ||= EasyAuth::Identity.find(session[:identity_id]).account
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
