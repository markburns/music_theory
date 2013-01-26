require File.expand_path('spec/spec_helper')

describe TwelveNoteScale do
  let(:scale) {
    module TestScale
      extend Scale
      extend TwelveNoteScale
      extend JustIntonation
    end
  }


  context 'even temperament' do
    specify do
      scale.notes.values.flatten.should =~ %w(A# C# D# F# G# C Db D Eb E F Gb G Ab A Bb B)
    end

    let(:octave) do {
      0    => {notes: %w(C     ), cents: 0.0},
      1    => {notes: %w(C# Db ), cents: 0.0},
      2    => {notes: %w(D     ), cents: 0.0},
      3    => {notes: %w(D# Eb ), cents: 0.0},
      4    => {notes: %w(E     ), cents: 0.0},
      5    => {notes: %w(F     ), cents: 0.0},
      6    => {notes: %w(F# Gb ), cents: 0.0},
      7    => {notes: %w(G     ), cents: 0.0},
      8    => {notes: %w(G# Ab ), cents: 0.0},
      9    => {notes: %w(A     ), cents: 0.0},
      10   => {notes: %w(A# Bb ), cents: 0.0},
      11   => {notes: %w(B     ), cents: 0.0}
    }
    end


    specify do
      scale.octave.should == octave
    end
  end

  context 'just intonation' do

    specify do
      scale.note_cent_intersection.should =~ (0..11).to_a
    end

    let(:octave) do
      {
        0    => {notes: %w(C     ), cents: 0.0   } ,
        1    => {notes: %w(C# Db ), cents: 0.0   } ,
        2    => {notes: %w(D     ), cents: 4.0   } ,
        3    => {notes: %w(D# Eb ), cents: 0.0   } ,
        4    => {notes: %w(E     ), cents: -14.0 } ,
        5    => {notes: %w(F     ), cents:  -2.0 } ,
        6    => {notes: %w(F# Gb ), cents: 0.0   } ,
        7    => {notes: %w(G     ), cents: 2.0   } ,
        8    => {notes: %w(G# Ab ), cents: 0.0   } ,
        9    => {notes: %w(A     ), cents: -16.0 } ,
        10   => {notes: %w(A# Bb ), cents: 0.0   } ,
        11   => {notes: %w(B     ), cents: -12.0 }
      }
    end


    specify do
      scale.octave.should == octave
    end
  end

end
