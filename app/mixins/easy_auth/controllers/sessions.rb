module EasyAuth::Controllers::Sessions
  def self.included(base)
    base.class_eval do
      before_filter :no_authentication, :except => :destroy
    end
  end

  def new
    EasyAuth.new_session(self)
  end

  def create
    if identity = EasyAuth.authenticate(self)
      identity.set_account_session(session)
      if identity.remember
        cookies[:remember_token] = { :value => identity.generate_remember_token!, :expires => identity.remember_time.from_now }
      end
      after_successful_sign_in(identity)
    else
      @identity = EasyAuth.password_identity_model.new(params[:password_identity])
      after_failed_sign_in(@identity)
    end
  end

  def destroy
    session.delete(:session_token)
    session.delete(:account_class)
    cookies.delete(:remember_token)
    after_sign_out
  end

  private

  def after_successful_sign_in(identity)
    redirect_to session.delete(:requested_path) || after_successful_sign_in_url(identity), :notice => I18n.t('easy_auth.sessions.create.notice')
  end

  def after_successful_sign_in_url(identity)
    identity.account
  end

  def after_failed_sign_in(identity)
    flash.now[:error] = I18n.t('easy_auth.sessions.create.error')
    render :new
  end

  def after_sign_out
    redirect_to main_app.root_url, :notice => I18n.t('easy_auth.sessions.delete.notice')
  end

  def no_authentication
    if account_signed_in?
      redirect_to no_authentication_url
    end
  end

  def no_authentication_url
    main_app.root_url
  end
end
