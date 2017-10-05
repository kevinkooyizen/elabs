class ChangeEventsTableNameToHappenings < ActiveRecord::Migration[5.1]
    def up
        rename_table :happenings, :happenings
    end

    def down
        rename_table :happenings, :happenings
    end
end
