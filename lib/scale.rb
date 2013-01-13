module Scale
  def self.included(base)
    base.class_eval do
      include Enumerable
    end
  end

  def initialize tuning=EvenTuning
    self.extend tuning
  end

  def note_cent_intersection
    notes.keys & cent_offsets.keys
  end

  def octave
    @output = {}

    note_cent_intersection.each do |scale_offset|
      names = notes[scale_offset]
      cents = cent_offsets[scale_offset]

      set_octave scale_offset, names, cents
    end

    @output
  end

  def set_octave scale_offset, names, cents
    note = @output[scale_offset] ||= {}

    note[:notes] ||= []
    note[:notes] += names
    note[:notes].uniq!
    note[:cents] = cents
  end
end
