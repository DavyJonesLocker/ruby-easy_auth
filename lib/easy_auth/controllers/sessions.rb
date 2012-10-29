module EasyAuth::Controllers::Sessions
  def self.included(base)
    base.class_eval do
      before_filter :no_authentication, :only => :new, :if => Proc.new { params[:identity] == :password }
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

  [:successful_sign_in, :successful_sign_in_url, :failed_sign_in].each do |method_name|
    define_method "after_#{method_name}" do |identity|
      send("#{__method__}_with_#{params[:identity]}", identity) || send("#{__method__}_default", identity)
    end
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
end
