module Scale
  extend self

  def notes
    {
      0    => %w(C     ),
      1    => %w(C# Db ),
      2    => %w(D     ),
      3    => %w(D# Eb ),
      4    => %w(E     ),
      5    => %w(F     ),
      6    => %w(F# Gb ),
      7    => %w(G     ),
      8    => %w(G# Ab ),
      9    => %w(A     ),
      10   => %w(A# Bb ),
      11   => %w(B     )
    }
  end

  def note_cent_intersection
    notes.keys | cent_offsets.keys
  end

  def octave
    @output = {}

    note_cent_intersection.each do |scale_offset|
      names = notes[scale_offset]
      cents = cent_offsets[scale_offset] || 0.0

      set_octave scale_offset, names, cents
    end

    @output
  end

  def set_octave scale_offset, names, cents
    note = @output[scale_offset] ||= {}

    note[:notes] ||= []
    note[:notes] |= names
    note[:cents] = cents
  end
end
