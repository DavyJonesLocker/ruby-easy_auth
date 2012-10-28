module EasyAuth::Mailers::PasswordReset
  def self.included(base)
    base.clear_action_methods!
  end

  def reset(id)
    @identity = EasyAuth.identity_model.find(id)
    @url = edit_password_url(@identity.reset_token)
    mail :to => @identity.account.email, :subject => 'Password reset'
  end
end
