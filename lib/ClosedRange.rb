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

  def to_s
    "[#{@lower},#{@upper}]"
  end
  def inspect
    to_s
  end

  def include?(num)
    @lower <= num && num <= @upper
  end

  def contain?(range)
    @lower <= range.lower && range.upper <= @upper
  end

  def ==(range)
    lower == range.lower && upper == range.upper
  end

  def *(range)
    ClosedRange.new(
      lower: range.lower < @lower ? @lower : range.lower,
      upper: @upper < range.upper ? @upper : range.upper
    )
  end

  def to_a
    (@lower..@upper).to_a
  end

  protected
  def lower
    @lower
  end
  def upper
    @upper
  end
end
