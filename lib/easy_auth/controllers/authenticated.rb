module EasyAuth::Controllers::Authenticated
  extend ActiveSupport::Concern

  included do
    before_filter :attempt_to_authenticate
  end
end
