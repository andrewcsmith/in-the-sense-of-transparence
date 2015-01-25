$:.unshift('./data')
require 'pry'
require 'praat'

begin
  vowelgrid = Praat.parse_file 'vowel.textgrid'
  formants = Praat.parse_file 'S7_smoothed_formants.Formants'

  vowels = vowelgrid.items[0].intervalss.select(&:has_text?)

  # Create an Array with each formant segment
  vowel_formants = vowels.map {|vowel|
    vowel.extract_formant(formants)
  }

  # Returns a pair: [num_frames, NMatrix_fit]
  formant_lines = vowel_formants.map {|vowel_formant|
    vowel_formant.least_squares_formant
  }
rescue
  binding.pry
end

binding.pry

