class KeyPrinter
  attr_reader :key
  delegate :range, to: :key

  def initialize key
    @key = key
  end

  def format cols
    output = cols.map{|c|c.to_s.rjust(12)}.join " |"
    "| #{output} |\n"
  end

  def print range
    output = format ["MIDI", "NOTE", "cent offset"]

    range.to_a.each do |midi|
      note = key.note midi
      if note
        columns = [ midi, note.note, note.cents]
        output << format(columns)
      end
    end

    output
  end


end
