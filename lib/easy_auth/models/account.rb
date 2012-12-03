module EasyAuth::Models::Account
  extend  EasyAuth::ReverseConcern

  reverse_included do
    # Relationships
    has_many :identities, :class_name => 'Identity', :as => :account, :dependent => :destroy
  end
end
