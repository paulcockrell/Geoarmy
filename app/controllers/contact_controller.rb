class ContactController < ApplicationController
before_filter :set_menu

    def index
    end

    def send_contact_form 
        if request.post?
            Mailer::deliver_message(params[:author])
            redirect_to :action => 'contact'
            flash[:notice] = "Thanks for your message!"
        end
    end


    private


   def set_menu
       set_active_menu("item50") # set active menu to geocaches
   end
end
