class Note
  attr_reader :tuning, :midi_number, :name, :decorator

  FREQUENCY_OF_MIDDLE_A = 440.0
  NOTES_PER_OCTAVE      = 12.0
  MIDDLE_A_MIDI         = 69

  delegate :name, :attributes, :to_s, to: :decorator

  def new_harmonic h
    midi_number, adjusted_cents = adjust_cents MidiFrequencyConverter.to_midi(frequency)

    TunedNote.new \
      reference_note: self,
      harmonic:       h,
      midi_number:    midi_number,
      adjusted_cents: adjusted_cents,
      tuning:         tuning
  end

  def adjust_cents midi_number
    midi_number, cents = [midi_number.round, (midi_number % 1.0)]

    adjusted_cents = tuning.cent_offsets[note_offset(midi_number)]

    midi_number = midi_number + (cents + adjusted_cents)/100.0

    return [midi_number, adjusted_cents]
  end

  def initialize options
    check_args options

    @tuning      = options[:tuning] || EvenTuning
    @cents       = options[:cents]  || 0.0
    @midi_number = options[:midi_number] + (@cents / 100.0)
  end

  def check_args options
    if options[:midi_number]
      unless options[:midi_number].is_a? Numeric
        raise ArgumentError, "missing midi_number option in Note.new"
      end
    end
    unless options[:tuning].is_a? Module
      raise ArgumentError, "tuning should be a module"
    end
  end

  def note_offset n=nil
     ((n|| midi_number) % 12).to_i
  end

  def note_name
    @note_name ||= MidiName.note_lookup[note_offset]
  end

  def decorator
    @decorator ||= NoteDecorator.new self
  end

  def frequency
    adjusted_cents = tuning.cent_offsets[note_offset]
    debugger unless adjusted_cents
    MidiFrequencyConverter.to_frequency midi_number + adjusted_cents / 100.0
  end

  def cents
    midi_number % 1.0
  end

  def factory
    @factory ||= NoteFactory.new tuning
  end

  def harmonics
    @harmonics ||= (1..7).inject({}) do |harmonics, n|
      harmonics[n] = new_harmonic n

      harmonics
    end
  end


  def harmonic_names
    harmonics.values.map(&:name)
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
