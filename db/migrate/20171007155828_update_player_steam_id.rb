class UpdatePlayerSteamId < ActiveRecord::Migration[5.1]
    def up
        execute "update players
            set steam_id = a.uid
            from (select id, cast(uid as integer) as uid from users) a
            where players.user_id = a.id"
    end

    def down
        execute "update players set steam_id = null"
    end
end
