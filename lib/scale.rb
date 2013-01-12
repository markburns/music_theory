module Scale
  def self.included(base)
    base.class_eval do
      include Enumerable
    end
  end

  def initialize tuning=EvenTuning
    self.extend tuning
  end

  def each
    notes.each {|n| yield n }
  end

  def octave
    @output = {}
    notes.each do |scale_offset, names|
      cent_offsets.each do |tuning_offset, cents|
        set_octave scale_offset, names, tuning_offset, cents
      end
    end

    @output
  end

  def set_octave scale_offset, names, tuning_offset, cents
    note = @output[scale_offset] ||= {}

    note[:notes] ||= []
    note[:notes] += names
    note[:notes].uniq!

    note = @output[tuning_offset] ||= {}
    note[:cents] = cents

    @output = @output.delete_if{|_, n| n[:notes].nil? }
  end
end
