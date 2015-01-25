$:.unshift('./lib')
require 'pry'
require 'praat'

begin
  textgrid = Praat.parse_file './data/word.textgrid'
  vowelgrid = Praat.parse_file './data/vowel.textgrid'
  pitch = Praat.parse_file './data/smoothed_pitch.pitch'

  vowels = vowelgrid.items[0].intervalss.select(&:has_text?)

  # Vowels is an Array with either the mean pitch (log2) of the vowel or nil for
  # unvoiced
  pitches = vowels.map {|interval|
    vector = Praat.pitch_vector(interval.extract_pitch(pitch))
    if vector.is_a? NMatrix
      vector = vector.log2.mean[0]
    end
    vector
  }

  min, max = pitches.compact.minmax

  vowel_pitch = pitches.each_with_index.map do |pitch, index| 
    text = vowels[index].text
    if pitch.nil?
      [text, nil]
    else
      [text, (pitch - min) / (max - min)]
    end
  end
rescue
  binding.pry
end

binding.pry

