class TunedNote < Note
  def initialize options
    super

    @reference_note = options[:reference_note]
    @adjusted_cents, @cents = @cents, @reference_note.cents
  end

  def to_s
    name = "\"#{self.name}\"".rjust 10
    "<#{self.class.name} #{tuning}: #{name} #{attributes}>"
  end

  def cents
    @adjusted_cents
  end
end
