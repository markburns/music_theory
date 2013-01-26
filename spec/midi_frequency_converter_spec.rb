require File.expand_path('spec/spec_helper')

describe MidiFrequencyConverter do
  module EvenTuningTest
    def cent_offsets
      {
       0 => 0.0,
       1 => 0.0,
       2 => 0.0,
       3 => 0.0,
       4 => 0.0,
       5 => 0.0,
       6 => 0.0,
       7 => 0.0,
       8 => 0.0,
       9 => 0.0,
       10 => 0.0,
       11 => 0.0
      }

    end
    extend MidiFrequencyConverter
  end


  end
