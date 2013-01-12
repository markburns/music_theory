require File.expand_path('spec/spec_helper')


describe Key do
  let(:key) { Key.new }
  let(:middle_a)   { Note.new(frequency: 440, name: "A4") }

  specify do
    notes = key.notes_by_name
    notes["A4"].midi_number.should == 69
    notes["A0"].midi_number.should == 21
    notes["A0"].midi_number.should == 21
  end

  specify do
    notes = key.notes_by_midi_number
    notes.find{|n| n.frequency == 440 }.midi_number.should == 69
    notes.each{|n| n.cents.should == 0.0 }
  end

  context "with just intonation" do
    let(:key) { Key.new "C", SevenNoteScale, JustIntonation }
    specify do
      notes = key.notes_by_name
      notes["A4"].midi_number.should == 69
      notes["A4"].cents.should == -16
      notes["B4"].cents.should == -12
      notes["C11"].cents.should == 0
    end

 end


end
