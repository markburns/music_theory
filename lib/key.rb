class Key
  attr_reader :scale, :key, :scale_klass, :tuning, :notes_by_name,
    :notes_by_midi_number

  DEFAULT_TUNING      = EvenTuning
  DEFAULT_SCALE_KLASS = TwelveNoteScale
  DEFAULT_KEY         = "C"

  def initialize options={}
    @key, @scale_klass, @tuning =
      options[:key]    || DEFAULT_KEY,
      options[:scale]  || DEFAULT_SCALE_KLASS,
      options[:tuning] || DEFAULT_TUNING

    check_args

    calculate_notes
  end

  ARBITRARILY_HIGH_DIFF = 400_000

  def nearest_note frequency
    target = Note.from frequency
    nearest       =    nil
    smallest_cent_diff = ARBITRARILY_HIGH_DIFF

    notes.each do |note|
      diff = NoteDiff.new note, target

      if diff.cents < smallest_cent_diff
        nearest        = note

        smallest_cent_diff = diff.cents
      end

   end

    nearest
  end

  def note midi
    notes_by_midi_number.find{|n| n.midi_number == midi }
  end

  def scale
    scale_klass.new.tap{|s| s.extend tuning}
  end

  def each_note range=nil
    range ||= 0..140
    octaves.map do |octave|
      scale.octave.each do |index, note_and_cents|
        note_names, cents = note_and_cents[:notes], note_and_cents[:cents]
        midi_number = ((octave+1) * 12) + index

        note_names.each do |name|
          yield octave, name, cents, midi_number
        end if range.include? midi_number
      end
    end
  end

  private

  def calculate_notes
    @notes_by_name = {}
    @notes_by_midi_number = SortedSet.new


    notes.each do |note|
      @notes_by_name[note.note] = note
      @notes_by_midi_number << note
    end
  end

  def notes
    notes = []
    each_note do |octave, note_name, cents, midi_number|
      note = Note.new name: note_name, midi_number: midi_number, cents: cents
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
