class NoteDecorator
  attr_reader :note

  delegate :note_name, :name, :midi_number, :octave, :frequency, :cents, :key, to: :note

  def initialize note
    @note = note
  end

  def attributes
    "midi: #{midi_number.to_s.ljust 3} #{frequency.round(2)}Hz"
  end

  def to_s
    name = "\"#{self.name}\"".rjust 10
    "<#{note.class.name} #{name} #{attributes}>"
  end

  def tuning
    key ? key.tuning : ''
  end

  def display_cents
    value = cents.round 1

    if value > 0
      " +#{value}c"
    elsif value == 0
      ""
    else
      " #{value}c"
    end
  end

  def name_without_cents
    [note_name, octave].join ""
  end

  def name
    [note_name, octave, display_cents].join("")
  end

  def calculate_note_name override
    override || Note::OCTAVE[midi_number % Note::NOTES_PER_OCTAVE]
  end
end

