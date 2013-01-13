require File.expand_path('spec/spec_helper')
require './lib/note'
require 'active_support/core_ext/numeric'

describe 'Note' do
  let(:note_factory) { NoteFactory.new }

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

  describe "#harmonics" do
    let(:middle_a) { Note.new midi_number: 69 }

    def harmonic_name_should_equal number, name
      should_equal_ignoring_whitespace middle_a.harmonics[number].name, name
    end

    def should_equal_ignoring_whitespace a,b
      a.gsub(/\s+/,'').should == b.gsub(/\s+/,'')
    end

    specify do
      harmonic_name_should_equal 1, "A5"
      harmonic_name_should_equal 2, "E6 +2.0"
      harmonic_name_should_equal 3, "A6"

      should_equal_ignoring_whitespace note_factory.from(233).name, "Bb3 -0.6"
    end

    (2..8).to_a.each do |h|
      specify "has the #{h}th harmonic" do
        middle_a.harmonics[h - 1].should == note_factory.from(440 * h)
      end
    end
  end
end
