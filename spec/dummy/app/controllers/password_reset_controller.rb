class PasswordResetController < ApplicationController
  include EasyAuth::PasswordReset

  private

  def after_successful_password_reset_path(identity)
    main_app.dashboard_path
  end
end
