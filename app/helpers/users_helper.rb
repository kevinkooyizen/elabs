module UsersHelper
    def is_resource_owner?(resource_user_id:nil)
        if current_user.id == resource_user_id
            true
        else
            false
        end
    end

    def get_occupation_list
        [['player','Player'], ['manager','Manager'], ['coach','Coach']]
    end
end
