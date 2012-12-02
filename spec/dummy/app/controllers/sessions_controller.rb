class SessionsController < ApplicationController
  include EasyAuth::Controllers::Sessions

  private

  def after_successful_sign_in_url
    main_app.dashboard_url
  end
end
