require 'java'
include Java
java_import 'Sound'
require './lib/music_theory'
require 'ruby-debug'

def threader object
  threads = []

  object.each do |o|
    threads << Thread.new do
      yield o
    end
  end

  threads.each{|t| t.join}
end




def play note
  threader note.harmonics do |_, h|
    puts "#{h.frequency.round 2}\n"
    Sound.new.play h.frequency, 1
  end
end

def chord notes
  threader notes do |n|
    note = Note.new midi_number: n + 69 - 24, tuning: EvenTuning
    play note
  end
end

chord [0,4,7]
chord [0,5,9]
chord [0,4,7]
