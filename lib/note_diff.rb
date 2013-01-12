class NoteDiff
  attr_reader :lower, :higher

  def initialize a,b
    @lower, @higher = [a,b].sort
  end

  def frequency
    @higher.frequency - @lower.frequency
  end

  def cents
    ((@higher.midi_number + @higher.cents / 100.0) -
    (@lower. midi_number + @lower.cents / 100.0)) * 100.0
  end

  def midi_note
    (@higher.midi_number - @lower.midi_number)
  end
end
