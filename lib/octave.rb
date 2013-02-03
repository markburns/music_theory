require 'ostruct'
require 'csv'

class Entry < OpenStruct
  def ratio
    Rational.new numerator, denominator
  end
end

entries = CSV.read( 'nums.csv', headers: true).
  entries.map{|e|
    Entry.new({
      denominator: e["denominator"].to_i,
      numerator:   e["numerator"].to_i,
      cents:       e["cents"].to_f,
      description: e["description"]
    })
  }

class Octave < Array
  def initialize entries
    super entries
  end

  def limit denominator
    select{|x| x.denominator < denominator }
  end
end


octave = Octave.new entries

require 'ruby-debug'
debugger

1
