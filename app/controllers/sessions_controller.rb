class SessionsController < ::ApplicationController
  def new
    @identity = EasyAuth::Identity.new
  end

  def create
    if identity = EasyAuth::Identity.authenticate(params[:identity])
      session[:identity_id] = identity.id
      after_successfull_sign_in(identity)
    else
      @identity = EasyAuth::Identity.new(params[:identity])
      after_failed_sign_in(@identity)
    end
  end

  private

  def after_successfull_sign_in(identity)
    redirect_to identity.account
  end
  
  def after_failed_sign_in(identity)
    render :action => :new
  end
end
