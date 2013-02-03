import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.SourceDataLine;

class Sound
  SAMPLE_RATE = 44100;

  def audio_format
    @audio_format ||= AudioFormat.new(Sound::SAMPLE_RATE, 16, 1, true, true);
  end

  def line
    @line ||= AudioSystem.getSourceDataLine(audio_format)
  end

  def play frequency, duration
    bytes = generate_sine_wave frequency, duration

    length = SAMPLE_RATE * bytes.length / 1000;

    open_line do
      line.write bytes, 0, bytes.length
    end
  end

  def open_line
    line.open audio_format
    line.start
    yield

    line.drain
    line.close
  end

  def generate_sine_wave(frequency, seconds)
    sampling_interval = (SAMPLE_RATE / frequency).to_f

    (seconds * SAMPLE_RATE).to_i.times.map do |i|
      angle = (2.0 * Math::PI * i) / sampling_interval
      Math.sin(angle) * 127
    end
  end

  def sequence *notes
    open_line do
      notes.each do |n|
        play n, 0.1
      end
    end
  end
end


sound = Sound.new

sound.sequence 220,330,440,550,660,770,110,550
sound.sequence 220,330,440,550,660,770,110,550

sound.sequence 220,330,440,550,660,770,110,550
sound.sequence 220,330,440,550,660,770,110,550
