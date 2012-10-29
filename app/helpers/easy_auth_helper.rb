module EasyAuthHelper
  def self.included(base)
    base.class_eval do
      helper_method :current_account, :current_user, :account_signed_in?, :user_signed_in?, :account_not_signed_in?, :user_not_signed_in?
    end
  end

  def current_account
    if session[:session_token] && session[:account_class]
      begin
        @current_account ||= session[:account_class].constantize.find_by_session_token(session[:session_token])
      rescue
        @current_account = nil
        session.delete(:session_token)
      end
    elsif cookies[:remember_token]
      begin
        @current_account ||= EasyAuth.identity_model.find_by_remember_token(cookies[:remember_token]).account
      rescue
        @current_acount = nil
        cookies.delete(:remember_token)
      end
    else
      session.delete(:session_token)
      cookies.delete(:remember_token)
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
