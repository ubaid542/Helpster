class ApplicationMailer < ActionMailer::Base
  default from: ENV['SMTP_USERNAME'] || 'ranaubaid542@gmail.com'
  layout "mailer"
end
