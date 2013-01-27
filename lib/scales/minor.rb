module Minor
  def self.included base
    base.class_eval do
      include Scale
    end
  end


  def self.notes
    {
      1  => %w(A),
      2  => %w(B),
      3  => %w(C),
      4  => %w(D),
      5  => %w(E),
      6  => %w(F),
      7  => %w(G)
    }
  end
end
