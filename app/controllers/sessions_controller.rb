class SessionsController < ::ApplicationController
  def new
    @identity = EasyAuth::Identity.new
  end

  def create
    if identity = EasyAuth::Identity.authenticate(params[:identity])
      session[:identity_id] = identity.id
      redirect_to after_sign_in_path_for(identity.account)
    else
      @identity = EasyAuth::Identity.new(params[:identity])
      render :action => :new
    end
  end

  private

  def after_sign_in_path_for(resource)
    resource
  end
end
