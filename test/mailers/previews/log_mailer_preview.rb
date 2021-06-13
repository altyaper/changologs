# Preview all emails at http://localhost:3000/rails/mailers/log_mailer
class LogMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/log_mailer/new_log
  def new_log
    log = Log.last
    LogMailer.new_log(log)
  end

  def deleted_log
    log = Log.last
    LogMailer.deleted_log(log)
  end

end
