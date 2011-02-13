require 'test_helper'

class ReminderMailerTest < ActionMailer::TestCase
  test "confirm" do
    @expected.subject = 'ReminderMailer#confirm'
    @expected.body    = read_fixture('confirm')
    @expected.date    = Time.now

    assert_equal @expected.encoded, ReminderMailer.create_confirm(@expected.date).encoded
  end

  test "sent" do
    @expected.subject = 'ReminderMailer#sent'
    @expected.body    = read_fixture('sent')
    @expected.date    = Time.now

    assert_equal @expected.encoded, ReminderMailer.create_sent(@expected.date).encoded
  end

end
