class RenameUsersName < ActiveRecord::Migration[5.1]
  def up
    rename_column :users, :name, :real_name
  end

  def down
    rename_column :users, :real_name, :name
  end
end
