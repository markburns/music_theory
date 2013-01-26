module Scale
  TWELVE_NOTES = %w(C C# D D# E F F# G G# A# B)

  def octave key
    octave = TWELVE_NOTES
    octave = octave.rotate until octave.first == key
    octave
  end
end
