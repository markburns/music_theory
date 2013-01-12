require File.expand_path('spec/spec_helper')


describe Key do
  let(:key) { Key.new }

  describe "#notes_by_name" do
    specify do
      notes = key.notes_by_name
      {
        "A4"  => 69,
        "A0"  => 21,
        "C0"  => 12,
        "Bb0" => 22,
        "A#0" => 22,
        "B0"  => 23,
        "C1"  => 24
      }.each do |n, midi|
        notes[n].midi_number.should == midi
      end

    end

    context "with just intonation" do
      let(:key) { Key.new key: "C", scale: SevenNoteScale, tuning: JustIntonation }
      specify do
        notes = key.notes_by_name
        notes["A4"].midi_number.should == 69
        notes["A4"].cents.should == -16
        notes["B4"].cents.should == -12
        notes["C10"].cents.should == 0
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
