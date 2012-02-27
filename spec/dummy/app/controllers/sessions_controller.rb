EasyAuth::Engine.require_dependency('sessions_controller')

class SessionsController

  private

  def after_sign_in_path_for(resource)
    main_app.dashboard_path
  end
end
