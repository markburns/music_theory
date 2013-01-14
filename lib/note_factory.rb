class NoteFactory
  class << self
    delegate :from, :in_tuning, :parse_midi, to: :new

    def default_key
      @key ||= Key.new
    end
  end

  def initialize key=NoteFactory.default_key
    @key = key
  end

  def from frequency_or_name, klass=Note
    midi_number, cents = to_midi_number_and_cents(frequency_or_name)
    klass.new key: @key, midi_number: midi_number, cents: cents
  end

  def from_midi midi_number, cents=0.0, klass=Note
    klass.new key: @key, midi_number: midi_number, cents: cents
  end

  def to_midi_number_and_cents frequency_or_name
    method_name = frequency_or_name.is_a?(Numeric) ? :parse_frequency : :parse_midi

    send(method_name, frequency_or_name)
  end

  def parse_frequency frequency
    value = Note::MIDDLE_A_MIDI + Note::NOTES_PER_OCTAVE *
      Math.log((frequency / Note::FREQUENCY_OF_MIDDLE_A), 2)

    [value.round, 100.0 * (value - value.round)]
  end

  delegate :parse_midi, to: :note_parser

  def note_parser
    @note_parser ||= NoteParser.new
  end
end
