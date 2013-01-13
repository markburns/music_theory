class NoteDecorator
  attr_reader :note

  delegate :name, :midi_number, :octave, :frequency, :cents, to: :note

  def initialize note
    @note = note
  end

  def attributes
    "midi: #{midi_number.to_s.ljust 3} | frequency: #{frequency.round(2)}Hz"
  end

  def to_s
    "<#{note.class.name} #{name.rjust 10} #{attributes}>"
  end

  def calculate_name override
    [(override  || note_name), octave, display_cents].join("")
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
    Note::OCTAVE[midi_number % Note::NOTES_PER_OCTAVE]
  end
end

