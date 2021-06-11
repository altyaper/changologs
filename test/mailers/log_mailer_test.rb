require 'test_helper'

class LogMailerTest < ActionMailer::TestCase
  test "new_log" do
    mail = LogMailer.new_log
    assert_equal "New log", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
