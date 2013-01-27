require File.expand_path('spec/spec_helper')

describe Scale do
  let(:klass) do
    Class.new do
      include Scale
    end
  end

  let(:instance) { klass.new }

  specify do
    instance.octave("C" ).should == %w(C C# D D# E F F# G G# A A# B)
    instance.octave("C#").should == %w(C# D D# E F F# G G# A A# B C)
    instance.octave("E" ).should == %w(E F F# G G# A A# B C C# D D#)
    instance.octave("B" ).should == %w(B C C# D D# E F F# G G# A A#)
    expect{instance.octave("Q" )}.to raise_error ArgumentError
    instance.octave("Eb" ).should == %w(Eb E F Gb G Ab A Bb B C Db D)
  end
end

describe Major do
  let(:klass) do
    Class.new do
      include Major
    end
  end

  let(:instance) { klass.new }

  specify do
    instance.octave("C" ).should == %w(C D E F G A B)
    instance.octave("Eb").should == %w(Eb F G Ab Bb C D)
    instance.octave("Gb").should == %w(Gb Ab Bb Cb Db Eb F)
    instance.octave("C#").should == %w(C# D# E# F# G# A# B#)
    instance.octave("E" ).should == %w(E F# G# A B C# D#)
    instance.octave("B" ).should == %w(B C# D# E F# G# A#)
  end

  specify do
    instance.convert(%w{C# D# F  F# G# A# C}).should ==
                     %w{C# D# E# F# G# A# B#}
  end
end
