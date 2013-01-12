require File.expand_path('spec/spec_helper')

describe KeyPrinter do
  let(:key) { Key.new scale: SevenNoteScale, tuning: JustIntonation }
  let(:key_formatter) { KeyPrinter.new key }

  def check range, output
    key_formatter.print_range(range).gsub(/\s*/,"").should == output.gsub(/\s*/, "")
  end

  specify "print range" do
    check 69..72, <<-eof
     |      MIDI |       NOTE | cent offset |
     |        69 |         A4 |         -16 |
     |        71 |         B4 |         -12 |
     |        72 |         C5 |           0 |
    eof
  end
end
