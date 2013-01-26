class NoteDiff
  attr_reader :a, :b

  def initialize a,b
    @a, @b = [a,b]
  end

  def to_s
    "<NoteDiff: (#{@a.name})->(#{@b.name}) #{frequency.round 2}Hz  #{cents.round 2}cents >"
  end

  def frequency
    @b.frequency - @a.frequency
  end

  def midi_number
    (@b. midi_number - @a.midi_number).round 2
  end

  def cents
    midi_number * 100.0
  end
end
