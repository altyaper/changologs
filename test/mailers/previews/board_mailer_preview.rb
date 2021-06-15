# Preview all emails at http://localhost:3000/rails/mailers/board_mailer
class BoardMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/board_mailer/shared_board
  def shared_board
    BoardMailer.shared_board(UserBoard.last)
  end

end
