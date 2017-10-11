class AddLargeAvatarToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :large_avatar_url, :string
  end
end
