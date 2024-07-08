class ApplicationMailer < ActionMailer::Base
  default from: ENV["MAILGUN_SENDER"]
  layout 'mailer'
end
