module EasyAuth::Controllers::Sessions
  extend ActiveSupport::Concern

  def new
    EasyAuth.new_session(self)
  end

  def create
    if @identity = EasyAuth.authenticate(self)
      session[:identity_id] = @identity.id
      after_successful_sign_in
    else
      @identity = EasyAuth.find_identity_model(params).new(params[params[:identity]])
      after_failed_sign_in
    end
  rescue AbstractController::DoubleRenderError
  end

  def destroy
    session.delete(:identity_id)
    after_sign_out
  end

  def after_with_or_default(method_name)
    send("#{method_name}_with_#{params[:identity]}") || send("#{method_name}_default")
  end

  def after_successful_sign_in
    after_with_or_default(__method__)
  end

  def after_successful_sign_in_url
    after_with_or_default(__method__)
  end

  def after_failed_sign_in
    after_with_or_default(__method__)
  end

  def after_successful_sign_in_default
    redirect_to(session.delete(:requested_path) || after_successful_sign_in_url, :notice => I18n.t('easy_auth.sessions.create.notice'))
  end

  def after_successful_sign_in_url_default
    @identity.account
  end

  def after_failed_sign_in_default
    flash.now[:error] = I18n.t('easy_auth.sessions.create.error')
    render :new
  end

  def after_sign_out
    redirect_to after_sign_out_url, :notice => I18n.t('easy_auth.sessions.delete.notice')
  end

  def after_sign_out_url
    main_app.root_url
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
    unless method_name.to_s =~ /after_\w+_with_\w+/
      super
    end
  end
end
