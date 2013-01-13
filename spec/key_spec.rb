require File.expand_path('spec/spec_helper')


describe Key do
  let(:key) { Key.new }
  let(:note_factory) { NoteFactory.new }

  describe "#notes_by_name" do
     {
        "A4"  => 69,
        "A0"  => 21,
        "C0"  => 12,
        "Bb0" => 22,
        "B0"  => 23,
        "C1"  => 24
      }.each do |n, midi|
        specify "#{n} maps to #{midi}" do
          notes = key.notes_by_name

        notes[n].midi_number.should == midi
      end

    end

    context "with just intonation" do
      let(:key) { Key.new scale: SevenNoteScale, tuning: JustIntonation }
      specify do
        notes = key.notes_by_name
        notes["A4"].midi_number.should == 69
        notes["A4"].cents.should == -16
        notes["B4"].cents.should == -12
        notes["C10"].cents.should == 0
      end
    end
  end

  describe "#nearest_notes" do
    context "with closer A" do
      let(:key) { Key.new range: 68..72, scale: SevenNoteScale, tuning: JustIntonation }
      let(:a_with_offset) { Note.new name: "A", midi_number: 69, cents: -16 }

      specify do
        key.nearest_note(440).should =~ a_with_offset
      end
    end

    context "with closer G#" do
      module TempIntonation
        def cent_offsets
          #Ab is +92 cents, A is +17 cents
          {8 => 92, 9 => 17}
        end
      end
      let(:key) { Key.new range: 68..70, tuning: TempIntonation }
      let(:a_flat_with_tuning) { Note.new midi_number: 68, cents: 92, name: "Ab#" }
      let(:middle_a)           { Note.new midi_number: 69                         }
      let(:a_with_tuning)      { Note.new midi_number: 69, cents: 17              }

      specify do
        key.nearest_note(440).should =~ a_flat_with_tuning
      end
    end

    let(:middle_a) { note_factory.from 440 }

    let(:key) { Key.new range: 68..75 }
    specify do
      expected = Note.new midi_number: 97

      nearest = key.nearest_note(440 * 5)
      nearest.should ==  expected
    end
  end

  context "transposing to different keys" do
    let(:key) { Key.new scale: SevenNoteScale, range: 60..75, key: "C#" }
    specify do
      [61,63,65,66,68,70,72,73].each do |n|
        key.note(n).should_not be_nil
      end
      [59,62,64,67,69,71,74].each do |n|
        key.note(n).should be_nil
      end
    end
  end

  describe "#notes_by_midi_number" do
    specify do
      notes = key.notes_by_midi_number
      notes.find{|n| n.frequency == 440 }.midi_number.should == 69
      notes.each{|n| n.cents.should == 0.0 }
    end
  end

  describe "#note" do
    specify do
      notes = key.notes_by_midi_number
      n = key.note(69)
      n.should be_a Note

      notes.find{|note| note.midi_number == 69 }.should == n
    end
  end
end
