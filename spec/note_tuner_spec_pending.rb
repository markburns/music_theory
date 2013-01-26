require File.expand_path('spec/spec_helper')

describe NoteTuner do
  describe "#tune" do
    let(:tuning)     { EvenTuning }
    let(:just)       { JustIntonation }
    let(:note_tuner) { NoteTuner.new tuning }

    def new_note cents, tuning
      note_tuner.new({cents: cents, midi_number: 69})
    end

    def just_note cents
      new_note cents, just
    end

    def even_note cents
      new_note cents, tuning
    end

    #Even                     Just
    #A4 -16.0 435.95Hz         0.0  435.95Hz
    #A4 -5.0  438.73Hz         11.0 438.73Hz
    #A4 0.0   440.0Hz          16.0
    #A4 +11.0 442.8Hz          27.0
    #A4 +27.0 446.92Hz         43.0

    {
      -16.0 => [435.95, 0.0],
      - 5.0 => [438.73, 11.0],
      + 0.0 => [440.00, 16.0],
      +11.0 => [442.80, 27.0]
    }.each do |even_cents, (frequency, just_cents)|
      context do
        specify "with #{even_cents} offset frequency: #{frequency} and just intonation offset #{just_cents}" do
          even = even_note(even_cents)
          just = just_note(just_cents)

          even.frequency.should be_within(0.01).of frequency
          just.frequency.should be_within(0.01).of frequency
        end
      end
    end
  end
end
