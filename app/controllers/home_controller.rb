class HomeController < ApplicationController
    before_filter :set_menu

    def index
        @current_user          = get_user
        @action_log            = ActionLog::get_actions(@current_user, 10)
        @last_found_geocache   = User.get_last_found_geocache(@current_user)
        @user_connection_count = User.get_connections_count(@current_user)
    end


    private

    def set_menu
        set_active_menu("item10")
    end

end
