class ApplicationMailer < ActionMailer::Base
  default from: ENV["CHANGOLOGS_MAILGUN_SENDER"]
  layout 'mailer'
end
