class BoardMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.board_mailer.shared_board.subject
  #
  def shared_board(relation)
    email = User.find(relation.user_id).email
    @board = Board.find(relation.board_id)
    mail to: email
  end
end
