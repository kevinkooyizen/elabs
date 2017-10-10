class ChangeApiIdItems < ActiveRecord::Migration[5.1]
  def up
    add_index :items, :api_id
  end

  def down
    remove_index :items, :api_id
  end
end
