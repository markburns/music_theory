class Note
  attr_reader :name, :midi_number, :cents

  def initialize options
    @name        = options[:name]
    @midi_number = options[:midi_number]
    @cents       = options[:cents] || 0.0
  end

  FREQUENCY_OF_MIDDLE_A = 440.0
  NOTES_PER_OCTAVE      = 12.0
  MIDDLE_A_MIDI         = 69

  def frequency
    m = midi_number + (cents/100.0)
    FREQUENCY_OF_MIDDLE_A * 2 **((m-MIDDLE_A_MIDI)/NOTES_PER_OCTAVE)
  end

  def octave
    ((midi_number / NOTES_PER_OCTAVE) - 1).floor
  end

  def attributes
    {name: name, midi_number: midi_number, cents: cents}
  end

  def to_s
    "<Note:0x#{object_id.to_s 16} #{attributes}>"
  end

  def note
    [name, octave].join ""
  end

  def <=> other
    frequency <=> other.frequency
  end
end
