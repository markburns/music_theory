require File.expand_path('spec/spec_helper')

describe KeyPrinter do
  let(:key) { Key.new scale: SevenNoteScale, tuning: JustIntonation }
  let(:key_printer) { KeyPrinter.new key }

  def check range, expected
    key_printer.print(range).split("\n").each_with_index do |output_line, index|
      output_line.gsub(/\s*/,"").should == expected.split("\n")[index].gsub(/\s*/, "")
    end
  end

  specify "print range" do
    check 69..72, <<-eof
     |      MIDI |       NOTE | standard tuning | cent offset | frequency |
     |        69 |         A4 |          440.0  |         -16 |    435.95 |
     |        71 |         B4 |         493.88  |         -12 |    490.47 |
     |        72 |         C5 |         523.25  |           0 |    523.25 |
    eof

    check 10..17, <<-eof
     |      MIDI |       NOTE | standard tuning | cent offset | frequency |
     |        12 |         C0 |          16.35  |           0 |     16.35 |
     |        14 |         D0 |          18.35  |           4 |      18.4 |
     |        16 |         E0 |          20.6   |         -14 |     20.44 |
     |        17 |         F0 |          21.83  |          -2 |      21.8 |
    eof
  end
end
