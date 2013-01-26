require File.expand_path('spec/spec_helper')

describe MidiName do
  specify do
    {
      "A4"        => [69.0, 440.00],
      "Bb4"       => [70.0, 466.16],
      "Bb4 +50.0" => [70.5, 479.82]
    }.each do |name, (midi, frequency)|
      note = MidiName.new(name)
    note.midi_number       .should == midi
    note.name              .should == name
    note.frequency.round(2).should == frequency.round(2)
    end
  end
end
