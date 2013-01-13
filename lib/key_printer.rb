class KeyPrinter
  attr_accessor :key
  delegate :range, to: :key
  delegate :standard_frequency, to: self

  def initialize key
    @key = key
  end

  def format cols
    output = cols.map{|c|c.to_s.rjust(12)}.join " |"
    "| #{output} |\n"
  end

  def self.standard_tuning
    @standard_tuning ||= Key.new
  end

  def self.standard_frequency midi
    standard_tuning.note(midi).frequency.round 2
  end

  def print range
    output = format ["MIDI", "NOTE", "standard tuning", "cent offset", "frequency"]

    range.to_a.each do |midi|
      note = key.note midi
      if note
        columns = [ midi, note.name_without_cents, standard_frequency(midi), note.cents, note.frequency.round(2)]
        output << format(columns)
      end
    end

    output
  end


end
