class Connection < ActiveRecord::Base
    belongs_to :users
    validates_presence_of :user_id, :connection_id
    after_save :log

    def log
        logme(self.user_id,self.connection_id,'connected with')
    end
end
