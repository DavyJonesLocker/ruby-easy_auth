module EasyAuth::Controllers::PasswordReset
  def self.included(base)
    base.instance_eval do
      before_filter :find_identity_from_reset_token, :only => [:edit, :update]
    end
  end

  def new
    @identity = EasyAuth.identity_model.new
  end

  def create
    if @identity = EasyAuth.identity_model.where(:username => params[:identity][:username]).first
      @identity.generate_reset_token!
      PasswordResetMailer.reset(@identity.id).deliver
    else
      @identity = EasyAuth.identity_model.new(params[:identity])
    end

    flash.now[:notice] = I18n.t('easy_auth.password_reset.create.notice')
    render :new
  end

  def update
    if @identity.update_attributes(scope_to_password_params(:identity))
      after_successful_password_reset(@identity)
    else
      after_failed_sign_in(@identity)
    end
  end

  private

  def scope_to_password_params(key)
    params[key].select { |k, v| ['password', 'password_confirmation'].include?(k) }
  end

  def find_identity_from_reset_token
    @identity = EasyAuth.identity_model.where(:reset_token => params[:reset_token].to_s).first
  end

  def after_successful_password_reset(identity)
    identity.set_account_session(session)
    identity.update_attribute(:reset_token, nil)
    redirect_to after_successful_password_reset_path(identity), :notice => I18n.t('easy_auth.password_reset.update.notice')
  end

  def after_successful_password_reset_path(identity)
    identity.account
  end

  def after_failed_password_reset(identity)
    flash.now[:error] = I18n.t('easy_auth.password_reset.update.error')
    render :new
  end
end
