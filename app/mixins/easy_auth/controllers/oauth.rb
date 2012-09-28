module EasyAuth
  module Controllers
    module Oauth
      def new
        redirect_to EasyAuth.send("#{params[:provider]}_identity_model").authenticate_url(oauth_callback_url(:provider => params[:provider]))
      end

      def create
        identity = EasyAuth.send("#{params[:provider]}_identity_model").authenticate(oauth_callback_url(:provider => params[:provider]), params[:code])
      end
    end
  end
end
