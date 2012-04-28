module EasyAuth::SessionsControllerMixin
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

  def destroy
    session.delete(:identity_id)
    after_sign_out
  end

  private

  def after_successfull_sign_in(identity)
    redirect_to session.delete(:requested_path) || after_successfull_sign_in_path(identity)
  end

  def after_successfull_sign_in_path(identity)
    identity.account
  end

  def after_failed_sign_in(identity)
    render :action => :new
  end

  def after_sign_out
    redirect_to main_app.root_path
  end
end
