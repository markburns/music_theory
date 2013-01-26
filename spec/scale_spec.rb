require File.expand_path('spec/spec_helper')

describe Scale do
  let(:klass) do
    Class.new do
      include Scale
    end
  end

  let(:instance) { klass.new }

  specify do
    instance.octave("C" ).should == %w(C C# D D# E F F# G G# A# B)
    instance.octave("C#").should == %w(C# D D# E F F# G G# A# B C)
    instance.octave("E" ).should == %w(E F F# G G# A# B C C# D D#)
    instance.octave("B" ).should == %w(B C C# D D# E F F# G G# A#)
  end
end
