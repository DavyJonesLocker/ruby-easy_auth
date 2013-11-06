class AddAuthenticatedPosts < ActiveRecord::Migration
  def change
    create_table :authenticated_posts do |t|
      t.string :title
      t.string :password
      t.timestamps
    end
  end
end
