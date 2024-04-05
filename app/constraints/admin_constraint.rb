class AdminConstraint
  attr_reader :player

  def initialize(request)
    @player = request.env["warden"].user
  end

  def self.matches?(request)
    new(request).authorized?
  end

  def authorized?
    @player.admin?
  end
end
