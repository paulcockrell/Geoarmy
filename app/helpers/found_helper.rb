module FoundHelper
    def count_all_found
        Found.find(:all, :conditions=>["DATE_SUB(CURDATE(), INTERVAL 7 DAY) <= created_at"]).count.to_s
    end
end
