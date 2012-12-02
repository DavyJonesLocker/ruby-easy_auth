class CreateEasyAuthIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.string  :username
      t.string  :token
      t.string  :account_type
      t.integer :account_id
      t.string  :type
      t.timestamps
    end

    add_index :identities, :username
  end
end
