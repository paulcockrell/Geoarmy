module FavoritesHelper
    def count_all_favorites
        Favorite.find(:all, :conditions=>["DATE_SUB(CURDATE(), INTERVAL 7 DAY) <= created_at"]).count.to_s
    end
end
