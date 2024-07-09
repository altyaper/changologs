class LogMailer < ApplicationMailer
  default from: 'no-reply@changologs.com'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.log_mailer.deleted_log.subject
  #

  def new_log(log)
    @log = log
    @board = log.board
    mail to: @board.user.email
  end

  def deleted_log(log)
    @log = log
    @board = log.board
    mail to: @board.user.email
  end
  
end
