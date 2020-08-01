require 'singleton'

class ClosedRange
  class InvalidClosedRangeError < StandardError

  end

  def self.empty
    ClosedRange::Empty.instance
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
    use_only_not_when_empty(range, when_empty: false) do
      @lower <= range.lower && range.upper <= @upper
    end
  end

  def ==(range)
    use_only_not_when_empty(range, when_empty: false) do
      lower == range.lower && upper == range.upper
    end
  end

  def *(range)
    use_only_not_when_empty(range, when_empty: ClosedRange.empty) do
      return ClosedRange.empty if range.upper < @lower || @upper < range.lower

      ClosedRange.new(
        lower: range.lower < @lower ? @lower : range.lower,
        upper: @upper < range.upper ? @upper : range.upper
      )
    end
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

  private def use_only_not_when_empty(range, when_empty:)
    case range
    when ClosedRange::Empty then
      when_empty
    else
      yield range
    end
  end

  class Empty
    include Singleton

    def to_s
      'empty'
    end
    def inspect
      to_s
    end

    def include?(_num)
      false
    end
    def contain?(_range)
      false
    end
    def to_a
      []
    end

    def *(_range)
      self
    end
  end
end
