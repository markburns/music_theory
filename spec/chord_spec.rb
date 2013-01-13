require File.expand_path('spec/spec_helper')

describe Chord do
  let(:key) { Key.new }
  let(:chord) { Chord.new key, "A4", "C#4", "E4" }
  let(:note_factory) { NoteFactory.new }

  specify do
    chord.length.should == 3
  end

  specify do
    chord.harmonics.should ==
     {
          "A4"  => ["A5",  "E6 +2.0"  , "A6"  , "Db7 -13.7" , "E7 +2.0"  , "G7 -31.2" , "A7"],
          "Db4" => ["Db5", "Ab5 +2.0" , "Db6" , "F6 -13.7"  , "Ab6 +2.0" , "B6 -31.2" , "Db7"],
          "E4"  => ["E5",  "B5 +2.0"  , "E6"  , "Ab6 -13.7" , "B6 +2.0"  , "D7 -31.2" , "E7"]
    }
  end

  context "just intonation" do

    let(:key) { Key.new(key: "A", tuning: JustIntonation) }
    specify do
      pending
      chord[1].should =~ note_factory.from("Db4")
    end

    specify do
      chord.harmonics["A4"].       should =~ ["A5"        , "E6 +2.0"   , "A6"        , "Db7 -13.7" , "E7 +2.0"   , "G7 -31.2" , "A7"]
      chord.harmonics["Db4 -14.0"].should =~ ["Db5 -14.0" , "Ab5 -12.0" , "Db6 -14.0" , "F6 -27.7"  , "Ab6 -12.0" , "B6 -45.2" , "Db7 -14.0"]
      chord.harmonics["E4 +2.0"].  should =~ ["Ab6 -11.7" , "B5 +4.0"   , "B6 +4.0"   , "D7 -29.2"  , "E5 +2.0"   , "E6 +2.0"  , "E7 +2.0"]
    end

    context "Just intonation in C, with adjusted harmonics" do
      let(:key) { Key.new(key: "C", tuning: JustIntonation) }
      let(:chord) { Chord.new key, "C4", "E4", "G4" }

      it "adjusts harmonics to the relevant tuning" do
        harmonics = chord.harmonics(in_key: true)

	pending
        harmonics["C4"].should == ["C5", "G5", "C6", "E6 +0.3", "G6", "Bb6 -31.2", "C7"]
        harmonics["E4"].should == ["E5"]
        harmonics["G4"].should == ["G5"]
      end
    end
  end
end
