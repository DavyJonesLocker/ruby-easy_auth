module EasyAuth::Controllers::Sessions
  extend EasyAuth::ReverseConcern

  def new
    EasyAuth.new_session(self)
  end

  def create
    if identity = EasyAuth.authenticate(self)
      identity.set_account_session(session)
      set_remember(identity)
      if identity.remember
        cookies[:remember_token] = { :value => identity.generate_remember_token!, :expires => identity.remember_time.from_now }
      end
      after_successful_sign_in(identity)
    else
      @identity = EasyAuth.find_identity_model(self).new(params[params[:identity]])
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

  def after_with_or_default(method_name, identity)
    send("#{method_name}_with_#{params[:identity]}", identity) || send("#{method_name}_default", identity)
  end

  def after_successful_sign_in(identity)
    after_with_or_default(__method__, identity)
  end

  def after_successful_sign_in_url(identity)
    after_with_or_default(__method__, identity)
  end

  def after_failed_sign_in(identity)
    after_with_or_default(__method__, identity)
  end

  def after_successful_sign_in_default(identity)
    redirect_to(session.delete(:requested_path) || after_successful_sign_in_url(identity), :notice => I18n.t('easy_auth.sessions.create.notice'))
  end

  def after_successful_sign_in_url_default(identity)
    identity.account
  end

  def after_failed_sign_in_default(identity)
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

  def method_missing(method_name, *args)
    # Swallow exceptions for identity callbacks
    unless method_name =~ /after_\w+_with_\w+/
      super
    end
  end

  def set_remember(identity)
    if identity_attributes = params[ActiveModel::Naming.param_key(EasyAuth.find_identity_model(self).new)]
      identity.remember = identity_attributes[:remember]
    end
  end
end
