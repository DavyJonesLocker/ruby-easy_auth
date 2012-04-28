class SessionsController < ApplicationController
  include EasyAuth::Sessions

  private

  def after_successfull_sign_in_path(identity)
    main_app.dashboard_path
  end
end
