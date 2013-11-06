class UnauthenticatedController < ApplicationController
  def show
    @authenticated_post = AuthenticatedPost.new(authenticated_post_params)
  end

  private

  def authenticated_post_params
      params.require(:authenticated_post).permit('title') if params[:authenticated_post]
  end
end
