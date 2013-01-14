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

  def cents
    diff = (((@b. midi_number + @b.cents / 100.0)) -
     (@a.midi_number + @a.cents / 100.0)) * 100.0

    diff.round 2
  end

  def midi_note
    (@b.midi_number - @a.midi_number)
  end
end
