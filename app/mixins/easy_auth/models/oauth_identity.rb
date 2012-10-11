require 'oauth2'
module EasyAuth::Models::OauthIdentity
  def self.included(base)
    base.class_eval do
      extend ClassMethods
    end
  end

  module ClassMethods
    def authenticate_url(callback_url)
      raise NotImplementedError
    end

    def authenticate(controller)
      raise NotImplementedError
    end

    def new_session(controller)
      raise NotImplementedError
    end

    private

    def client
      raise NotImplementedError
    end

    def authorize_url
      raise NotImplementedError
    end

    def token_url
      raise NotImplementedError
    end

    def site_url
      raise NotImplementedError
    end
  end
end
