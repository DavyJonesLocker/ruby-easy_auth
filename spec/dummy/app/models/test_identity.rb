class TestIdentity < Identity
  def self.authenticate(controller)
    TestIdentity.first
  end
end
