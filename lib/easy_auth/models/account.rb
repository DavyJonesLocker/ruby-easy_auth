module EasyAuth::Models::Account
  extend ActiveSupport::Concern

  included do
    # Relationships
    has_many :identities, :class_name => 'Identity', :as => :account, :dependent => :destroy, :autosave => true
  end
end
