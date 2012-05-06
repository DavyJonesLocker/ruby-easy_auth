class CreateEasyAuthIdentities < ActiveRecord::Migration
  def change
    create_table :easy_auth_identities do |t|
      t.string  :username
      t.string  :password_digest
      t.string  :account_type
      t.integer :account_id
      t.string  :reset_token
      t.string  :session_token

      t.timestamps
    end
    [:username, :reset_token, :session_token].each do |column|
      add_index :easy_auth_identities, column
    end
  end
end
