require File.expand_path('spec/spec_helper')

describe NoteDiff do
  let(:tuning) { EvenTuning }
  let(:c) { Note.new tuning: tuning, name: "C", midi_number: 60 }
  let(:d) { Note.new tuning: tuning, name: "D", midi_number: 62 }
  let(:note_diff) { NoteDiff.new c, d }

  specify do
    note_diff.a.should == c
    note_diff.b.should == d

    c_freq = 261.625565300599
    d_freq = 293.664767917408
    note_diff.frequency.round(2).should == (d_freq - c_freq).round(2)
    note_diff.cents.should == 200
  end

  specify do
    debugger
    c = Note.new tuning: tuning, name: "C",  midi_number: 60, cents: 17
    d = Note.new tuning: tuning, name: "Db", midi_number: 61, cents: -2

    NoteDiff.new(c, d).cents.should == (100 - 17 - 2)
  end


end
