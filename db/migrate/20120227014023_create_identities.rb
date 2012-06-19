class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.string  :username
      t.string  :password_digest
      t.string  :account_type
      t.integer :account_id
      t.string  :reset_token
      t.string  :remember_token
      t.timestamps
    end

    [:username, :reset_token, :remember_token].each do |column|
      add_index :identities, column
    end
  end
end
