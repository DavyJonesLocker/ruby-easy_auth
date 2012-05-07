class SessionsController < ApplicationController
  include EasyAuth::Controllers::Sessions

  private

  def after_successful_sign_in_path(identity)
    main_app.dashboard_path
  end
end
