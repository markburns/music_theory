module KeyPrinter
  extend self

  def format cols
    output = cols.map{|c|c.to_s.rjust(12)}.join " |"
    "| #{output} |\n"
  end

  def print range
    output = format ["MIDI", "NOTE", "standard tuning", "cent offset", "frequency"]

    range.to_a.each do |midi|
      note = key.note midi
      next unless note

      columns = [
        midi,
        note.name,
        standard_frequency(midi),
        note.cents, note.frequency.round(2)
      ]
      output << format(columns)
    end

    output
  end
end
