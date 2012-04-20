class AuthenticatedController < ApplicationController
  before_filter :redirect_to_root_if_not_signed_in

  private

  def redirect_to_root_if_not_signed_in
    if user_not_signed_in?
      redirect_to root_path
    end
  end
end
