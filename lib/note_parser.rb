class NoteParser
  NOTE_REGEX_STRING     = "[A-G](#|b)?"
  OCTAVE_REGEX_STRING   = "-?\\d+"
  CENT_REGEX_STRING     = "( (\\+|-)\\d+(\\.\\d+)?)?"

  def parse_midi name
    unless name =~ note_regex
      raise ArgumentError, "Unrecognized note name #{name}"
    end

    note   = name[note_regex]
    octave = name[octave_regex].to_i

    cents  = (name[cent_regex] || 0.0).to_f
    note_offset = Key::TRANSPOSITION[note]

    midi_number = ((octave+1) * Note::NOTES_PER_OCTAVE) + note_offset

    return midi_number, cents
  end

  private

  def full_note_regex
    /#{
      [
        NOTE_REGEX_STRING,
        OCTAVE_REGEX_STRING,
        CENT_REGEX_STRING
    ].join ""
    }/
  end

  def note_regex
    /\A#{NOTE_REGEX_STRING}/
  end

  def cent_regex
    /#{CENT_REGEX_STRING}\z/
  end

  def octave_regex
    /#{OCTAVE_REGEX_STRING}/
  end
end

