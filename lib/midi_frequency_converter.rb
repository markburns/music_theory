module MidiFrequencyConverter
  A_MIDI_NUMBER =  69.0
  A_FREQUENCY   = 440.0

  def to_frequency midi
    A_FREQUENCY * 2**((midi-A_MIDI_NUMBER)/Note::NOTES_PER_OCTAVE)
  end

  def to_midi frequency
    A_MIDI_NUMBER + Note::NOTES_PER_OCTAVE * Math.log(frequency/440.0, 2.0)
  end

  extend self
end
