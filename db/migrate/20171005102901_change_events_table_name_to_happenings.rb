class ChangeEventsTableNameToHappenings < ActiveRecord::Migration[5.1]
    def up
        rename_table :events, :happenings
    end

    def down
        rename_table :happenings, :events
    end
end
