class Favorite < ActiveRecord::Base
    has_many :geocaches
    belongs_to :user
    after_save :log

    def log
        logme(self.user_id,self.id,'added to their favorites')
    end
end
