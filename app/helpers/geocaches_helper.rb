module GeocachesHelper

    def generate_center_marker(point)
        centerMarker = "<script type=\"text/javascript\">var centerMarker=[#{point[0]},#{point[1]}];</script>"
    end

    def generate_map_markers(points)
        markers = "<script type=\"text/javascript\">"
        markers += "var geocaches = ["
        arr_length = points.count
        points.each_with_index do |p,i|
            markers += "['#{i}',#{p[0]['lat']},#{p[0]['lon']},#{p[0]['index']},'#{p[0]['name']}']"
            if i < arr_length-1
                markers += ","
            end
        end 
        markers += "];</script>"
        markers
    end

    def count_all_geocaches
        Geocache.find(:all).count
    end

    def count_new_geocaches
        Geocache.find(:all, :conditions=>["DATE_SUB(CURDATE(), INTERVAL 7 DAY) <= created_at"]).count.to_s
    end

end

