module EasyAuth::Controllers::PasswordReset
  def self.included(base)
    base.instance_eval do
      before_filter :find_identity_from_reset_token, :only => [:edit, :update]
    end
  end

  def new
    @identity = EasyAuth.password_identity_model.new
  end

  def create
    if @identity = EasyAuth.password_identity_model.where(:username => params[:identities_password][:username]).first
      @identity.generate_reset_token!
      PasswordResetMailer.reset(@identity.id).deliver
    else
      @identity = EasyAuth.password_identity_model.new(params[:identities_password])
    end

    flash.now[:notice] = I18n.t('easy_auth.password_reset.create.notice')
    render :new
  end

  def update
    if @identity.update_attributes(scope_to_password_params(:identities_password))
      after_successful_password_reset(@identity)
    else
      after_failed_password_reset(@identity)
    end
  end

  private

  def scope_to_password_params(key)
    { :password => params[key][:password], :password_confirmation => params[key][:password_confirmation] }
  end

  def find_identity_from_reset_token
    @identity = EasyAuth.password_identity_model.where(:reset_token => params[:reset_token].to_s).first
    @identity.password_reset = true
  end

  def after_successful_password_reset(identity)
    identity.set_account_session(session)
    identity.update_column(:reset_token, nil)
    redirect_to after_successful_password_reset_url(identity), :notice => I18n.t('easy_auth.password_reset.update.notice')
  end

  def after_successful_password_reset_url(identity)
    identity.account
  end

  def after_failed_password_reset(identity)
    flash.now[:error] = I18n.t('easy_auth.password_reset.update.error')
    render :edit
  end
end
