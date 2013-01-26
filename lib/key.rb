class Key
  attr_reader :scale, :key, :tuning, :range, :notes_by_name,
    :notes_by_midi_number

  DEFAULT_TUNING      = EvenTuning
  DEFAULT_SCALE_KLASS = TwelveNoteScale
  DEFAULT_RANGE       = 0..140
  DEFAULT_KEY         = "C"

  def initialize options={}
    @key, @scale_klass, @range, @tuning =
      options[:key]    || DEFAULT_KEY,
      options[:scale]  || DEFAULT_SCALE_KLASS,
      options[:range]  || DEFAULT_RANGE,
      options[:tuning] || DEFAULT_TUNING

    @transpose_offset = MidiName::TRANSPOSITION[@key]
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


  def note midi_number
    notes_by_midi_number.find midi_number
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
      @notes_by_name[note.name] = note
      @notes_by_midi_number << note
    end
  end

  def notes
    @notes ||= create_notes
  end

  def create_notes
    notes = []
    each_note do |midi_number, cents|
      note = Note.new midi_number: midi_number, cents: cents, tuning: tuning
      notes << note
    end

    notes
  end

  def check_args
    scale_ok  = scale.is_a?(Module)
    key_ok    = key.is_a?(String)
    tuning_ok = tuning.instance_methods.include?(:cent_offsets)

    ArgumentError.new unless scale_ok and key_ok and tuning_ok
  end

  def octaves
    (0..11).to_a
  end
end
