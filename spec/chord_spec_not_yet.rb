require File.expand_path('spec/spec_helper')

pending Chord do
  let(:tuning) { EvenTuning }
  let(:chord) { Chord.new tuning, "A4", "C#4", "E4" }

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
    let(:tuning) { JustIntonation }

    specify do
      note = chord[1]
      note.should =~ tuning.note("Db4")
    end

    specify do
      chord.harmonics["A4"].       should =~ ["A5"        , "E6 +2.0"   , "A6"        , "Db7 -13.7" , "E7 +2.0"   , "G7 -31.2" , "A7"]
      chord.harmonics["Db4 -14.0"].should =~ ["Db5 -14.0" , "Ab5 -12.0" , "Db6 -14.0" , "F6 -27.7"  , "Ab6 -12.0" , "B6 -45.2" , "Db7 -14.0"]
      chord.harmonics["E4 +2.0"].  should =~ ["Ab6 -11.7" , "B5 +4.0"   , "B6 +4.0"   , "D7 -29.2"  , "E5 +2.0"   , "E6 +2.0"  , "E7 +2.0"]
    end

    context "Just intonation in C, with adjusted harmonics" do
      let(:tuning) { JustIntonation }
      let(:chord) { Chord.new tuning, "C4", "E4", "G4" }

      it "adjusts harmonics to the relevant tuning" do
        harmonics = chord.harmonics(in_tuning: true)

        harmonics["C4"].should == ["C5", "G5", "C6", "E6 +0.3", "G6", "Bb6 -31.2", "C7"]
        harmonics["E4"].should == ["E5"]
        harmonics["G4"].should == ["G5"]
      end
    end
  end
end