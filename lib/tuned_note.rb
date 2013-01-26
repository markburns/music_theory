class TunedNote < Note
  attr_reader :reference_note, :harmonic

  def initialize options
    super

    @reference_note = options[:reference_note]
    @harmonic       = options[:harmonic]
  end

  def to_s
    name = "\"#{self.name}\"".rjust 10
    "<#{self.class.name} #{tuning}: #{name} #{attributes}>"
  end

  def frequency
    reference_note.frequency * (harmonic+1)
  end

  def cents
    @midi_number.round - @midi_number
  end

  def midi_number
    MidiFrequencyConverter.to_midi(frequency)
  end

  def name
    cents     = pseudo_note.decorator.display_cents
    note_name = pseudo_note.note_name
    octave    = pseudo_note.octave

    [ note_name, octave, cents].join ""
  end

  def pseudo_note
    @pseudo_note ||=
      Note.new midi_number: midi_number, tuning: tuning
  end
end
