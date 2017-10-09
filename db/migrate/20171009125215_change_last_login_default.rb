class ChangeLastLoginDefault < ActiveRecord::Migration[5.1]
  def up
    remove_column :players, :last_login

    add_column :players, :last_login, :date, default: Date.today
  end

  def down
    remove_column :players, :last_login

    add_column :players, :last_login, :string
  end
end
