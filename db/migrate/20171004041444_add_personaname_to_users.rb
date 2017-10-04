class AddPersonanameToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :persona_name, :string
  end
end
