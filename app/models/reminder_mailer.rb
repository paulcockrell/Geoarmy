class ReminderMailer < ActionMailer::Base
  

  def password(user)
    subject    'ReminderMailer#confirm'
    recipients user.email
    from       "support@geopirate.net"
    sent_on    Time.now
    @body["user"] =user
  end

  def username(user)
    subject    'Username reminder for Geopirate.net'
    recipients user.email
    from       "support@geopirate.net"
    sent_on    Time.now
    @body["user"] =user       
  end

end
