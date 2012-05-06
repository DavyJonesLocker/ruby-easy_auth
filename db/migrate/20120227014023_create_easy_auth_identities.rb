class CreateEasyAuthIdentities < ActiveRecord::Migration
  def change
    create_table :easy_auth_identities do |t|
      t.string  :username
      t.string  :password_digest
      t.string  :account_type
      t.integer :account_id
      t.string  :reset_token

      t.timestamps
    end
  end
end
