class UpdateAvatarInUsers < ActiveRecord::Migration[5.1]
    def up
        execute "update users
                   set avatar_url = b.avatar
                    from (select * from players) as b
                    where users.id = b.user_id;"
    end

    def down
        execute "update users
                   set avatar_url = NULL;"
    end

end
