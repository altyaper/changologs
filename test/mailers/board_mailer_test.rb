require 'test_helper'

class BoardMailerTest < ActionMailer::TestCase
  test "shared_board" do
    mail = BoardMailer.shared_board
    assert_equal "Shared board", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
