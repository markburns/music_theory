require File.expand_path('spec/spec_helper')

describe NoteFactory do
  let(:note_factory) { NoteFactory.new }

  describe ".from" do
    let(:middle_a) { Note.new midi_number: 69 }
    let(:a_sharp) { Note.new midi_number: 58 }
    let(:c_sharp) { Note.new name: "C#", midi_number: 97, cents: -14 }


    specify do
      note_factory.from(440).should == middle_a
      note_factory.from(440).name == "A4"
      note_factory.from(441).should =~ middle_a
      note_factory.from(440*5).should =~ c_sharp
      note_factory.from(233).name.gsub(/\s+/,'').should == ("Bb3 -0.6").gsub(/\s+/,'')
    end
  end

  describe "#in_tuning" do
    let(:key) { Key.new tuning: JustIntonation }
    let(:note) { note_factory.in_tuning(key, 440) }

    specify { note.should be_a Note }
  end
end
