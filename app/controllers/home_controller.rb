class HomeController < ApplicationController
before_filter :set_menu

    def index
        @current_user       = get_user
        @uploaded_geocaches = @current_user.geocaches.paginate :page => params[:page], :order => 'id', :per_page => 10 unless @current_user.nil?
        @favorite_geocaches = Geocache.all(:joins=>{:favorites, :user}, :conditions=>['users.id=?', @current_user.id]).paginate :page => params[:page], :order => 'id', :per_page => ITEMS_PER_PAGE if params[:id].nil? unless @current_user.nil?
        @found_geocaches    = Geocache.all(:joins=>{:found, :user}, :conditions=>['users.id=?', @current_user.id], :select=>'geocaches.id,geocaches.name,found.created_at as found,lat,lon', :order=>"found ASC").paginate :page => params[:page], :order => 'found ASC', :per_page => ITEMS_PER_PAGE if params[:id].nil? unless @current_user.nil?
    end


    private

    def set_menu
        set_active_menu("item10")
    end

end
