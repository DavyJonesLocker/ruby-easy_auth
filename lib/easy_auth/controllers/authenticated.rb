module EasyAuth::Controllers::Authenticated
  extend EasyAuth::ReverseConcern

  reverse_included do
    before_filter :attempt_to_authenticate
  end

  private

  def attempt_to_authenticate
    if account_not_signed_in?
      session[:requested_path] = request.path
      respond_to do |format|
        format.html { redirect_to main_app.sign_in_url }
        format.json { render :json => {}, :status => 401 }
      end
    end
  end
end
