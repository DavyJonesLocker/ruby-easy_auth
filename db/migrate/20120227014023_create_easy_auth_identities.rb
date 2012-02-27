class CreateEasyAuthIdentities < ActiveRecord::Migration
  def change
    create_table :easy_auth_identities do |t|
      t.string  :email
      t.string  :password_digest
      t.string  :account_type
      t.integer :account_id

      t.timestamps
    end
  end
end
