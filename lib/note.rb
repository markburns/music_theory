class Note
  attr_reader :midi_number, :cents, :name

  FREQUENCY_OF_MIDDLE_A = 440.0
  NOTES_PER_OCTAVE      = 12.0
  MIDDLE_A_MIDI         = 69

  OCTAVE = %w(C Db D Eb E F Gb G Ab A Bb B)

  class << self
    def from frequency
      midi_note, cents = midi_note_from(frequency)
      new midi_number: midi_note, cents: cents
    end

    def midi_note_from frequency
      value = MIDDLE_A_MIDI +
        NOTES_PER_OCTAVE *
        Math.log((frequency / FREQUENCY_OF_MIDDLE_A), 2)
      [value.floor, 100.0 * (value - value.floor)]
    end
  end

  def initialize options
    @midi_number = options[:midi_number]
    @cents       = options[:cents] || 0.0
    @name        = calculate_name options[:name]
  end

  def calculate_name name_override
    [(name_override  || note_name), octave, display_cents].join ""
  end

  def display_cents
    value = cents.round 1

    if value > 0
      " +#{value}"
    elsif value == 0
      ""
    else
      " #{value}"
    end
  end

  def name_without_cents
    [note_name, octave].join ""
  end


  def note_name
    OCTAVE[midi_number % NOTES_PER_OCTAVE]
  end

  def octave
    midi_number / NOTES_PER_OCTAVE
  end

  def harmonics
    10.times.map{|c| Note.from( frequency * (c+1)) }
  end

  def frequency
    m = midi_number + (cents/100.0)
    FREQUENCY_OF_MIDDLE_A * 2 **((m-MIDDLE_A_MIDI)/NOTES_PER_OCTAVE)
  end

  def octave
    ((midi_number / NOTES_PER_OCTAVE) - 1).floor
  end

  def attributes
    "frequency: #{frequency.round(2)}Hz"
  end

  def format h
    h.inject(""){|r,(k,v)| "#{r}, #{k}: #{v}" }
  end

  def diff other
    NoteDiff.new self, other
  end

  def to_s
    "<Note #{attributes}>"
  end

  def <=> other
    frequency <=> other.frequency
  end

  def == other
    attributes == other.attributes
  end

  def =~ other
    diff(other).cents < 5
  end
end
