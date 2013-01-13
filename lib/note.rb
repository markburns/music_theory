class Note
  attr_reader :midi_number, :cents, :name, :decorator

  FREQUENCY_OF_MIDDLE_A = 440.0
  NOTES_PER_OCTAVE      = 12.0
  MIDDLE_A_MIDI         = 69

  OCTAVE = %w(C Db D Eb E F Gb G Ab A Bb B)

  delegate :name_without_cents, :attributes, :to_s, :note_name, to: :decorator

  def initialize options
    @midi_number = options[:midi_number]
    @cents       = options[:cents] || 0.0
    @decorator   = NoteDecorator.new self
    @name        = @decorator.calculate_name(options[:name])
  end

  def harmonics
    @harmonics ||= (2..8).map do |c|
      NoteFactory.new.from(frequency * c, Harmonic)
    end.unshift nil
  end

  def harmonic_names
    harmonics[1..-1].map(&:name)
  end

  def frequency
    m = midi_number + (cents/100.0)
    FREQUENCY_OF_MIDDLE_A * 2 **((m-MIDDLE_A_MIDI)/NOTES_PER_OCTAVE)
  end

  def octave
    ((midi_number / NOTES_PER_OCTAVE) - 1).floor
  end

  def diff other
    NoteDiff.new self, other
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
