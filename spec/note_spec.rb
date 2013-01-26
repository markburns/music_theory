require File.expand_path('spec/spec_helper')
require './lib/note'
require 'active_support/core_ext/numeric'

describe 'Note' do
  let(:note_factory) { NoteFactory }
  let(:tuning) { EvenTuning }

    {
      [140, 0.0 ]  => 26_579.50,
      [69,  0.0 ]  => 440.0,
      [61,  50.0 ] => 285.3,
      [60,  0.0 ]  => 261.6,
      [0,   0.0 ]  => 8.1
    }.
    each do |(midi_number, cents), frequency|
      context "with #{midi_number} it has frequency" do
        let(:note) { Note.new cents: cents, midi_number: midi_number, tuning: tuning}
        let(:frequency) { frequency }

        specify "of #{frequency}" do
          note.frequency.should be_within(0.1).of frequency
        end
      end
    end

  {
    140 => 10,
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
      let(:note) { Note.new tuning: tuning, name: "C", midi_number: midi_number }
      specify do
	note.octave.should == octave
      end
    end
  end

  describe "diff" do
    let(:c) { Note.new tuning: tuning, name: "C", midi_number: 60 }
    let(:d) { Note.new tuning: tuning, name: "D", midi_number: 61 }

    specify do
      c.diff(d).should be_a NoteDiff
    end
  end

  describe ".new" do
    let(:even_tuning) { EvenTuning }
    let(:just_tuning) { JustIntonation }

    def new_note cents, tuning
      Note.new cents: cents, midi_number: 69, tuning: tuning
    end

    def just_note cents
      new_note cents, just_tuning
    end

    def even_note cents
      new_note cents, tuning
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
    let(:middle_a) { Note.new midi_number: 69, tuning: tuning }

    def harmonic_should_equal number, name
      equal_except_whitespace middle_a.harmonics[number].name, name
    end

    def equal_except_whitespace a,b
      a.gsub(/\s+/,'').should == b.gsub(/\s+/,'')
    end

    specify do
      harmonic_should_equal 1, "A5"
      harmonic_should_equal 2, "E6 +2.0c"
      harmonic_should_equal 3, "A6"
    end

    (1..7).to_a.each do |h|
      specify "has the #{h}th harmonic" do
        harmonic = middle_a.harmonics[h]
        harmonic.frequency.should == middle_a.frequency * (h+1)
      end
    end
  end
end
