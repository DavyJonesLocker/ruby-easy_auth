EasyAuth::Engine.require_dependency('sessions_controller')

class SessionsController

  private

  def after_successfull_sign_in(identity)
    redirect_to main_app.dashboard_path
  end
end
