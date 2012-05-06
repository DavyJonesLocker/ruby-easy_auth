module EasyAuth::PasswordReset
  def self.included(base)
    base.instance_eval do
      before_filter :find_identity_from_reset_token, :only => [:edit, :update]
    end
  end

  def new
    @identity = EasyAuth::Identity.new
  end

  def create
    if @identity = EasyAuth::Identity.where(:username => params[:identity][:username]).first
      @identity.password_reset
    else
      @identity = EasyAuth::Identity.new(params[:identity])
    end

    render :action => :new
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
    @identity = EasyAuth::Identity.where(:reset_token => params[:reset_token]).first
  end

  def after_successful_password_reset(identity)
    session[:identity_id] = @identity.id
    redirect_to after_successful_password_reset_path(identity)
  end

  def after_successful_password_reset_path(identity)
    identity.account
  end

  def after_failed_password_reset(identity)
    render :action => :new
  end
end
