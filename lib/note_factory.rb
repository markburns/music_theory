module NoteFactory
  extend self

  def from frequency_or_name, klass=Note
    midi_number, cents = to_midi_number_and_cents(frequency_or_name)
    klass.new midi_number: midi_number, cents: cents
  end

  def to_midi_number_and_cents frequency_or_name
    method_name = frequency_or_name.is_a?(Numeric) ? :parse_frequency : :parse_midi

    send(method_name, frequency_or_name)
  end

  def in_tuning key, frequency_or_name
    midi_number, _ = to_midi_number_and_cents(frequency_or_name)

    key.note midi_number
  end

  def parse_frequency frequency
    value = Note::MIDDLE_A_MIDI +
      Note::NOTES_PER_OCTAVE *
      Math.log((frequency / Note::FREQUENCY_OF_MIDDLE_A), 2)
    [value.round, 100.0 * (value - value.round)]
  end

  NOTE_REGEX_STRING     = "[A-G](#|b)?"
  OCTAVE_REGEX_STRING   = "-?\\d+"
  CENT_REGEX_STRING     = "( (\\+|-)\\d+(\\.\\d+)?)?"

  FULL_REGEX_STRING = [
    NOTE_REGEX_STRING,
    OCTAVE_REGEX_STRING,
    CENT_REGEX_STRING
  ].join ""

  NOTE_OCTAVE_CENT_REGEX = /\A#{FULL_REGEX_STRING}\z/

  def parse_midi name
    unless name =~ NOTE_OCTAVE_CENT_REGEX
      raise ArgumentError, "Unrecognized note name #{name}"
    end

    note   = name[/\A#{NOTE_REGEX_STRING}/]
    octave = name[/#{OCTAVE_REGEX_STRING}/].to_i

    cents  = (name[/#{CENT_REGEX_STRING}\z/] || 0.0).to_f
    note_offset = Key::TRANSPOSITION[note]

    midi_number = ((octave+1) * Note::NOTES_PER_OCTAVE) + note_offset

    return midi_number, cents
  end
end
