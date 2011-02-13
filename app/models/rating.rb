class Rating < ActiveRecord::Base
    belongs_to :geocaches
    belongs_to :users
    validates_presence_of :geocache_id, :geocache_rating, :user_id
    before_save :check_rating

    private 

    def check_rating
        (1..5).include?(self.geocache_rating)
    end
end
