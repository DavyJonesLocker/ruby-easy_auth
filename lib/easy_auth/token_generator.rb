module EasyAuth::TokenGenerator
  private

  def _generate_token(type)
    token = BCrypt::Password.create("#{id}-#{type}_token-#{DateTime.current}")
  end
end
