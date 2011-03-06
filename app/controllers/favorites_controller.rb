class FavoritesController < ApplicationController
before_filter :prepare_for_mobile

  def index
  end
  
  def add_favorite
      user = get_user
      geo = Hash["geocache_id", params[:id], "user_id", user.id]
      @favorite = Favorite.new(geo)
      if request.post? and @favorite.save
          respond_to do |format|
            format.html {render :partial => 'favorite_del', :object => params[:id]}
            format.mobile { render :partial => "del_favorite.mobile" }
          end
      end
  end

  def delete_favorite
      if request.post?
          user = get_user
          @favorite = Favorite.find(:first, :conditions=>['geocache_id = ? and user_id = ?', params[:id],user.id])
          @favorite.destroy
          respond_to do |format|
            format.html {render :partial => 'favorite', :object => params[:id]}
            format.mobile { render :partial => "add_favorite.mobile" }
          end
      end
  end

end
