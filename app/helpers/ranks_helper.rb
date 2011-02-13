module RanksHelper
    def get_rank_image(rank)
        Rank.find(:all, :select=>'image', :conditions=>['ranks.from <= ? and ranks.to >= ?',rank,rank])
    end

    def get_rank_name(rank)
        Rank.find(:all, :select=>'rank', :conditions=>['ranks.from <= ? and ranks.to >= ?',rank,rank])
    end
end
