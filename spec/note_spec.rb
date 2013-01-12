require File.expand_path('spec/spec_helper')
require './lib/note'

describe 'Note' do
  context "with different midi number" do
    {
      [140, 0.0 ]  => 26_579.50,
      [69,  0.0 ]  => 440.0,
      [61,  50.0 ] => 285.3,
      [60,  0.0 ]  => 261.6,
      [0,   0.0 ]  => 8.1
    }.each do |(midi_number, cents), frequency|
    context "with #{midi_number} it has frequency" do
      let(:note) { Note.new name: "C", cents: cents, midi_number: midi_number }
      let(:frequency) { frequency }
      specify "of #{frequency}" do
	note.frequency.should be_within(0.1).of frequency
      end
    end
    end
  end

     {
      140  => 10,
      69  => 4,
      61  => 4,
      57  => 3,
      56  => 3,
      13  => 0,
      12  => 0,
      11  => -1,
      0   => -1
    }.each do |midi_number, octave|
    context "midi number #{midi_number} has octave" do
      let(:note) { Note.new name: "C", midi_number: midi_number }
      specify do
        note.octave.should == octave
      end
    end
  end

  describe "diff" do
    let(:c) { Note.new name: "C", midi_number: 60 }
    let(:d) { Note.new name: "D", midi_number: 61 }

    specify do
      c.diff(d).should be_a NoteDiff
    end
  end

  describe "#from" do
    let(:middle_a) { Note.new midi_number: 69 }
    specify do
      Note.from(440).should == middle_a
      Note.from(441).should =~ middle_a
    end
  end

end
