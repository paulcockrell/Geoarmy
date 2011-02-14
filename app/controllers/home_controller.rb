class HomeController < ApplicationController
    before_filter :set_menu

    def index
        @current_user = get_user
    end


    private

    def set_menu
        set_active_menu("item10")
    end

end
