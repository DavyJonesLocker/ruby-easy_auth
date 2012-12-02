module EasyAuth::TokenGenerator
  private

  def _generate_token(type)
    token = Digest::SHA2.hexdigest("#{id}-#{type}_token-#{DateTime.current}")
  end
end
