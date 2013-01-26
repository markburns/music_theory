class MidiName
  attr_reader :midi_number, :name, :octave

  TRANSPOSITION = {
    "Cb"  => -1,
    "C"  => 0,
    "C#" => 1,
    "Db" => 1,
    "D"  => 2,
    "D#" => 3,
    "Eb" => 3,
    "E"  => 4,
    "Fb" => 4,
    "E#" => 5,
    "F"  => 5,
    "F#" => 6,
    "Gb" => 6,
    "G"  => 7,
    "G#" => 8 ,
    "Ab" => 8,
    "A"  => 9,
    "A#" => 10,
    "Bb" => 10,
    "B"  => 11,
    "B#" => 12
  }

  def self.note_lookup
    {
      0 =>  "C" ,
      1 =>  "Db",
      2 =>  "D" ,
      3 =>  "Eb",
      4 =>  "E" ,
      5 =>  "F" ,
      6 =>  "Gb",
      7 =>  "G" ,
      8 =>  "Ab",
      9 =>  "A" ,
      10 => "Bb",
      11 => "B"
    }
  end


  NOTE_REGEX_STRING     = "[A-G](#|b)?"
  OCTAVE_REGEX_STRING   = "-?\\d+"
  CENT_REGEX_STRING     = "( (\\+|-)\\d+(\\.\\d+)?)?"

  def initialize name, tuning = EvenTuning
    unless name =~ note_regex
      raise ArgumentError, "Unrecognized note name #{name}"
    end
    @name = name

    note    =  name[note_regex]
    @octave = (name[octave_regex] || 5  ).to_i
    cents   = (name[cent_regex  ] || 0.0).to_f

    @note_offset = TRANSPOSITION[note]
    @cent_offset = cents + tuning.cent_offsets[@note_offset]


    midi_number = ((octave+1) * Note::NOTES_PER_OCTAVE) + @note_offset

    @midi_number = midi_number + @cent_offset/100.0
    @tuning = tuning
  end

  def frequency
    440.0 * 2**((@midi_number-MIDDLE_A_MIDI_NOTE)/Note::NOTES_PER_OCTAVE)
  end

  MIDDLE_A_MIDI_NOTE = 69.0

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
