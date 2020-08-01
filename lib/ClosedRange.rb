class ClosedRange
  def initialize(lower:, upper:)
    @lower = lower
    @upper = upper
  end

  def to_s()
    "[#{@lower},#{@upper}]"
  end
end
