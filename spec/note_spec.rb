require File.expand_path('spec/spec_helper')
require './lib/note'
require 'active_support/core_ext/numeric'

describe 'Note' do
  let(:note_factory) { NoteFactory }
  let(:key) { Key.new }

  context "with different midi number" do
    {
      [140, 0.0 ]  => 26_579.50,
      [69,  0.0 ]  => 440.0,
      [61,  50.0 ] => 285.3,
      [60,  0.0 ]  => 261.6,
      [0,   0.0 ]  => 8.1
    }.each do |(midi_number, cents), frequency|
    context "with #{midi_number} it has frequency" do
      let(:note) { Note.new name: "C", cents: cents, midi_number: midi_number, key: key}
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
    pending "midi number #{midi_number} has octave" do
      let(:note) { Note.new key: key, name: "C", midi_number: midi_number }
      specify do
        note.octave.should == octave
      end
    end
  end

  describe "diff" do
    let(:c) { Note.new key: key, name: "C", midi_number: 60 }
    let(:d) { Note.new key: key, name: "D", midi_number: 61 }

    specify do
      c.diff(d).should be_a NoteDiff
    end
  end

  describe ".new" do
    let(:key) { Key.new }
    let(:just) { Key.new tuning: JustIntonation }
    let(:note_tuner) { NoteTuner.new }

    def new_note cents, key
      Note.new cents: cents, midi_number: 69, key: key
    end

    def just_note cents
      new_note cents, just
    end

    def even_note cents
      new_note cents, key
    end

    #Even                     Just
    #A4 -16.0 435.95Hz         0.0
    #A4 -5.0  438.73Hz         11.0
    #A4 0.0   440.0Hz          16.0
    #A4 +11.0 442.8Hz          27.0
    #A4 +27.0 446.92Hz         43.0

    {
      -16.0 => [435.95, 0.0],
      - 5.0 => [438.73, 11.0],
      + 0.0 => [440.00, 16.0],
      +11.0 => [442.80, 27.0]
    }.each do |even_cents, (frequency, just_cents)|
    specify "with #{even_cents} offset frequency: #{frequency} and just intonation offset #{just_cents}" do
      even = even_note(even_cents)

      just = just_note(just_cents)
      even.frequency.should be_within(0.01).of frequency
      just.frequency.should be_within(0.01).of frequency
    end
    end
  end

  describe "#harmonics" do
    let(:middle_a) { Note.new midi_number: 69, key: key }

    def harmonic_should_equal number, name
      equal_except_whitespace middle_a.harmonics[number].name, name
    end

    def equal_except_whitespace a,b
      a.gsub(/\s+/,'').should == b.gsub(/\s+/,'')
    end

    specify do
      pending
      harmonic_should_equal 1, "A5"
      harmonic_should_equal 2, "E6 +2.0"
      harmonic_should_equal 3, "A6"

      equal_except_whitespace note_factory.from(233).name, "Bb3 -0.6"
    end

    (1..7).to_a.each do |h|
      specify "has the #{h}th harmonic" do
        pending
        middle_a.harmonics[h].should == note_factory.from(440 * (1 + h))
      end
    end
  end
end
