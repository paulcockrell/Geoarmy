class FavoritesController < ApplicationController

  def index
  end
  
  def add_favorite
      user = get_user
      geo = Hash["geocache_id", params[:id], "user_id", user.id]
      @favorite = Favorite.new(geo)
      if request.post? and @favorite.save
          render :partial => 'favorite_del', :object => params[:id]
      end
  end

  def delete_favorite
      if request.post?
          user = get_user
          @favorite = Favorite.find(:first, :conditions=>['geocache_id = ? and user_id = ?', params[:id],user.id])
          @favorite.destroy
          render :partial => 'favorite', :object => params[:id]
      end
  end

end
