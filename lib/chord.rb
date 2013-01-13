class Chord < Array
  def initialize key, *notes
    @key = key
    super notes.map {|c| key.note c}
  end

  def harmonics in_key=false
    not_in_key_harmonics
  end

  def not_in_key_harmonics
    inject({}) { |total, n| total.merge({n.name => n.harmonic_names })}
  end
end
