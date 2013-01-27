module Major
  def self.included base
    base.class_eval do
      include Scale

      def notes key="C"
        notes = rotate all_notes(key), key
        output = []
        [0,2,4,5,7,9,11].each{ |i| output << notes[i] }
        output
      end

      def convert notes
        mapping = if (notes.first =~ /b\z/)
          {"E" => "Fb", "B" => "Cb"}
        elsif notes.first =~ /#\z/
          {"F" => "E#", "C" => "B#"}
        else
          {}
        end

        notes.map { |x| mapping[x] || x }
      end
    end
  end
end
