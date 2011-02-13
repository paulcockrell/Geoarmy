module UserHelper

    def count_all_users
        User.find(:all).count.to_s
    end

end
