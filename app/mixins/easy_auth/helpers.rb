module EasyAuth
  module Helpers
    def self.included(base)
      base.class_eval do
        helper_method :current_user, :user_signed_in?, :user_signed_out?
      end
    end

    def current_user
      if session[:identity_id]
        @current_user ||= EasyAuth::Identity.find(session[:identity_id]).account
      end

      @current_user
    end

    def user_signed_in?
      !!current_user
    end

    def user_signed_out?
      !user_signed_in?
    end

  end
end
