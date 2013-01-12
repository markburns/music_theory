class Note
  attr_reader :name, :midi_number, :cents

  FREQUENCY_OF_MIDDLE_A = 440.0
  NOTES_PER_OCTAVE      = 12.0
  MIDDLE_A_MIDI         = 69


  class << self
    def from frequency
      midi_note, cents = midi_note_from(frequency)
      new midi_number: midi_note, cents: cents
    end

    def midi_note_from frequency
      value = MIDDLE_A_MIDI +
        NOTES_PER_OCTAVE *
        Math.log((frequency / FREQUENCY_OF_MIDDLE_A), 2)
      [value.floor, value - value.floor]
    end
  end

  def initialize options
    @name        = options[:name]
    @midi_number = options[:midi_number]
    @cents       = options[:cents] || 0.0
  end

  def frequency
    m = midi_number + (cents/100.0)
    FREQUENCY_OF_MIDDLE_A * 2 **((m-MIDDLE_A_MIDI)/NOTES_PER_OCTAVE)
  end

  def octave
    ((midi_number / NOTES_PER_OCTAVE) - 1).floor
  end

  def attributes
    {frequency: frequency, name: name, midi_number: midi_number, cents: cents}
  end

  def diff other
    NoteDiff.new self, other
  end

  def to_s
    "<Note #{attributes}>"
  end

  def note
    [name, octave].join ""
  end

  def <=> other
    frequency <=> other.frequency
  end

  def == other
    attributes == other.attributes
  end

  def =~ other
    diff(other).cents < 0.5
  end
end
