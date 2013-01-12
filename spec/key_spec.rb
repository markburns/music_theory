require File.expand_path('spec/spec_helper')


describe Key do
  let(:key) { Key.new }

  specify do
    notes = key.notes_by_name
    notes["A4"]  .midi_number.should == 69
    notes["A0"]  .midi_number.should == 21
    notes["C0"]  .midi_number.should == 12
    notes["Bb0"] .midi_number.should == 22
    notes["A#0"] .midi_number.should == 22
    notes["B0"]  .midi_number.should == 23
    notes["C1"]  .midi_number.should == 24
  end

  specify do
    notes = key.notes_by_midi_number
    notes.find{|n| n.frequency == 440 }.midi_number.should == 69
    notes.each{|n| n.cents.should == 0.0 }
  end

  context "with just intonation" do
    let(:key) { Key.new key: "C", scale: SevenNoteScale, tuning: JustIntonation }
    specify do
      notes = key.notes_by_name
      notes["A4"].midi_number.should == 69
      notes["A4"].cents.should == -16
      notes["B4"].cents.should == -12
      notes["C11"].cents.should == 0
    end

 end


end
