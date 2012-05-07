module EasyAuth::Sessions
  def new
    @identity = EasyAuth::Identity.new
  end

  def create
    if identity = EasyAuth::Identity.authenticate(params[:identity])
      session[:session_token] = identity.generate_session_token!
      after_successful_sign_in(identity)
    else
      @identity = EasyAuth::Identity.new(params[:identity])
      after_failed_sign_in(@identity)
    end
  end

  def destroy
    session.delete(:session_token)
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
