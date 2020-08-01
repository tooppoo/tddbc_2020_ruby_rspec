class ClosedRange
  class InvalidClosedRangeError < StandardError

  end

  def initialize(lower:, upper:)
    @lower = lower
    @upper = upper

    if @lower > @upper
      raise InvalidClosedRangeError
    end
  end

  def to_s()
    "[#{@lower},#{@upper}]"
  end
end
