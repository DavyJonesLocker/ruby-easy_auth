class PasswordResetMailer < ActionMailer::Base
  default from: "from@example.com"

  def reset(id)
    @identity = EasyAuth::Identity.find(id)
    @url = edit_password_url(@identity.reset_token)
    mail :to => @identity.account.email, :subject => 'Password reset'
  end
end
