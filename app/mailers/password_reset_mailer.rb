class PasswordResetMailer < ActionMailer::Base
  include EasyAuth::Mailers::PasswordReset
  default :from => 'from@example.com'
end
