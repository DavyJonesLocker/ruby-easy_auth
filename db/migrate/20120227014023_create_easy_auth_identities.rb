class CreateEasyAuthIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.string  :username
      t.string  :token
      t.string  :account_type
      t.integer :account_id
      t.string  :reset_token
      t.string  :remember_token
      t.string  :type
      t.timestamps
    end

    [:username, :reset_token, :remember_token].each do |column|
      add_index :identities, column
    end

    # modify this table name if you are using a model other than User
    # for the account
    add_column :users, :session_token, :string
  end
end
