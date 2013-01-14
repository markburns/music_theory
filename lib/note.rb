class Note
  attr_reader :note_name, :key, :midi_number, :name, :decorator

  FREQUENCY_OF_MIDDLE_A = 440.0
  NOTES_PER_OCTAVE      = 12.0
  MIDDLE_A_MIDI         = 69

  OCTAVE = %w(C Db D Eb E F Gb G Ab A Bb B)

  delegate :name, :tuning, :name_without_cents, :attributes, :to_s, to: :decorator

  def initialize options
    @midi_number = options[:midi_number]
    @tuning      = options[:tuning] || EvenTuning
    @cents       = options[:cents] || 0.0

    @decorator   = NoteDecorator.new self
    @note_name   = @decorator.calculate_note_name options[:name]

    check_args
  end

  def check_args
    %w(midi_number key  cents).each do |a|
      raise ArgumentError, "missing #{a} option in Note.new" unless instance_variable_get :"@#{a}"
    end
  end

  def cents
    @cents
  end

  def add_cents c, klass=nil
    self.new_with({cents: @cents + c}, klass)
  end

  def new_with options, klass=Note

    defaults = {
      midi_number: @midi_number,
      key:         @key,
      cents:       @cents,
      note_name:   @note_name,
      reference_note: self
    }

    klass.new(defaults.merge options)
  end

  def factory
    @factory ||= NoteFactory.new key
  end

  def harmonics
    @harmonics ||= (1..7).inject({}) do |harmonics, n|
      harmonics[n] = factory.in_tuning(frequency * (n+1))

      harmonics
    end
  end

  def harmonic_names
    harmonics.values.map(&:name)
  end

  def frequency
    m = midi_number + (@cents/100.0)
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
