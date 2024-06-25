class FriendMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.friend_mailer.new_friendship.subject
  #
  def new_friendship(current_user, destination_user_id)
    destination_user = User.find(destination_user_id)
    @from_user = current_user
    mail to: destination_user.email
  end
end
