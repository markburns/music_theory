class Key
  attr_reader :scale, :key, :scale_klass, :tuning, :range, :notes_by_name,
    :notes_by_midi_number

  DEFAULT_TUNING      = EvenTuning
  DEFAULT_SCALE_KLASS = TwelveNoteScale
  DEFAULT_RANGE       = 0..140
  DEFAULT_KEY         = "C"

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

  def initialize options={}
    @key, @scale_klass, @range, @tuning =
      options[:key]    || DEFAULT_KEY,
      options[:scale]  || DEFAULT_SCALE_KLASS,
      options[:range]  || DEFAULT_RANGE,
      options[:tuning] || DEFAULT_TUNING

    @transpose_offset = TRANSPOSITION[@key]
    check_args

    calculate_notes
  end

  def inspect
    "<Key '#{@key}' #{@scale_klass} #{@tuning} \n#{nice_octave}\n    >"
  end

  def nice_octave
    nice = scale.octave.values.inject({}){|r, v|
      values = v.values.flatten
      values.last.is_a?(String) ? values.reverse! : values
      r[values.first] = values.last
      r

    }

    output = []
    nice.each do |k,v|
      output << "      #{k.ljust(3)}: #{v}"
    end
    output.join "\n"
  end

  ARBITRARILY_HIGH_DIFF = 400_000

  def nearest_note frequency
    target             = NoteFactory.from frequency
    nearest            = nil
    smallest_cent_diff = ARBITRARILY_HIGH_DIFF

    notes.each.with_index do |note, next_note_index|
      diff = NoteDiff.new note, target

      if diff.cents.abs < smallest_cent_diff.abs
        nearest = note

        smallest_cent_diff = diff.cents
      end
   end

    nearest
  end

  def note midi_number, cents=0.0, klass=nil
    m, _ =
      if midi_number.is_a?(String)
        NoteFactory.parse_midi(midi_number)
      else
        [midi_number, cents]
      end

    note = notes_by_midi_number.find{|n| n.midi_number == m }

    note.new_with cents: cents
  end

  def scale
    @scale ||= scale_klass.new.tap{|s| s.extend tuning}
  end

  def each_note range=nil
    range ||= 0..140

    octaves.map do |octave|
      scale.octave.each do |index, note_and_cents|
        cents = note_and_cents[:cents]
        midi_number = ((octave+1) * 12) + index + @transpose_offset

        yield midi_number, cents if range.include? midi_number
      end
    end
  end

  private

  def calculate_notes
    @notes_by_name = {}
    @notes_by_midi_number = SortedSet.new

    notes.each do |note|
      @notes_by_name[note.name_without_cents] = note
      @notes_by_midi_number << note
    end
  end

  def notes
    @notes ||= create_notes
  end

  def create_notes
    notes = []
    each_note do |midi_number, cents|
      note = Note.new midi_number: midi_number, cents: cents, key: self
      notes << note
    end

    notes
  end

  def check_args
    scale_ok  = scale_klass.ancestors.include?(Scale)
    key_ok    = key.is_a?(String)
    tuning_ok = tuning.instance_methods.include?(:cent_offsets)

    ArgumentError.new unless scale_ok and key_ok and tuning_ok
  end

  def octaves
    (0..11).to_a
  end
end
