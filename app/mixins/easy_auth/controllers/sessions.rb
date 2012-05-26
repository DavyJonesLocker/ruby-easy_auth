module EasyAuth::Controllers::Sessions
  def new
    @identity = EasyAuth.identity_model.new
  end

  def create
    if identity = EasyAuth.identity_model.authenticate(params[:identity])
      session[:session_token]  = identity.generate_session_token!
      cookies[:remember_token] = { :value => identity.generate_remember_token!, :expires => identity.remember_time.from_now }
      after_successful_sign_in(identity)
    else
      @identity = EasyAuth.identity_model.new(params[:identity])
      after_failed_sign_in(@identity)
    end
  end

  def destroy
    session.delete(:session_token)
    cookies.delete(:remember_token)
    after_sign_out
  end

  private

  def after_successful_sign_in(identity)
    redirect_to session.delete(:requested_path) || after_successful_sign_in_path(identity), :notice => I18n.t('easy_auth.sessions.create.notice')
  end

  def after_successful_sign_in_path(identity)
    identity.account
  end

  def after_failed_sign_in(identity)
    flash.now[:error] = I18n.t('easy_auth.sessions.create.error')
    render :new
  end

  def after_sign_out
    redirect_to main_app.root_path, :notice => I18n.t('easy_auth.sessions.delete.notice')
  end
end
