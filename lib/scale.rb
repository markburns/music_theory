module Scale
  TWELVE_SHARP_NOTES = %w(C C# D D# E F F# G G# A A# B)
  TWELVE_FLAT_NOTES  = %w(C Db D Eb E F Gb G Ab A Bb B)

  def octave key="C"
    raise ArgumentError, "Invalid key: #{key}" unless (TWELVE_FLAT_NOTES + TWELVE_SHARP_NOTES).include? key

    convert rotate notes(key), key
  end

  def convert notes
    notes
  end

  def rotate notes, key
    rotated = notes.dup

    notes.each do |o|
      if rotated.first != key
        rotated = rotated.rotate
      end
    end

    rotated
  end

  def notes key
    all_notes key
  end

  def all_notes key
    key =~ /b\z/ ? TWELVE_FLAT_NOTES : TWELVE_SHARP_NOTES
  end
end
