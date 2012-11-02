class TestIdentity < EasyAuth::Identity
  def self.authenticate(controller)
    TestIdentity.first
  end
end
