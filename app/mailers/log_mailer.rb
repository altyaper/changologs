class LogMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.log_mailer.new_log.subject
  #
  def new_log(log)
    @log = log
    @board = log.board
    mail to: @board.user.email
  end
end
