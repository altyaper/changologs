# Preview all emails at http://localhost:3000/rails/mailers/friend_mailer
class FriendMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/friend_mailer/new_friendship
  def new_friendship
    FriendMailer.new_friendship(User.last, Friendship.last.friend_b_id)
  end

end
