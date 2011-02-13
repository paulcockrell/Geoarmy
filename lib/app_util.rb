module MyActiveRecordExtensions
    
    def logme(userid, geocacheid, action)
        action_log = ActionLog.new
        action_log[:users_id] = userid
        action_log[:geocaches_id] = geocacheid
        action_log[:action] = action
        action_log.save
    rescue
        errors.add_to_base("Failed to write action to action log")
        logger.warn("--- something is wrong when logging events in the action logger")
    end

end

ActiveRecord::Base.send(:include, MyActiveRecordExtensions)

