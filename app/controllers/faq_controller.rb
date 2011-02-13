class FaqController < ApplicationController
before_filter :set_menu

    def set_menu
        session[:active_menu] = "item40"
    end
    
    def index
    end

end
