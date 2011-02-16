class Found < ActiveRecord::Base
    has_many :geocaches
    belongs_to :user
    after_save :log

    def log
        logme(self.user_id,self.geocache_id,'found geocache')
    end

    def self.history(id)
        find(:all, :conditions=>['geocache_id=?',id])
    end

    def self.get_last_found(user_id)
        find(:all, :conditions=>['user_id=? order by created_at ASC limit 1', user_id])
    end
end
