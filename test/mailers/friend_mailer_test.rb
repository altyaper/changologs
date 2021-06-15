require 'test_helper'

class FriendMailerTest < ActionMailer::TestCase
  test "new_friendship" do
    mail = FriendMailer.new_friendship
    assert_equal "New friendship", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
