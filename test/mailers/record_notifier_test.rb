require 'test_helper'

class RecordNotifierTest < ActionMailer::TestCase
  test "created" do
    mail = RecordNotifier.created
    assert_equal "Created", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "deleted" do
    mail = RecordNotifier.deleted
    assert_equal "Deleted", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "accessed" do
    mail = RecordNotifier.accessed
    assert_equal "Accessed", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
