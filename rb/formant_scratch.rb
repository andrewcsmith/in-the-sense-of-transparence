File.open "formant_lines.json", "r" do |f|
  @formant_lines = JSON.parse(f.read, :symbolize_names => true)
end

formant_offsets = @formant_lines.map {|f|
  f.last.map(&:first)
}.to_nm

formant_slopes = @formant_lines.map {|f|
  f.last.map(&:last)
}.to_nm

scaling = -> (matrix, sym) {
  NMatrix.new(matrix.shape, matrix.send(sym).to_a, dtype: :float64)
}

offset_mins = scaling.call(formant_offsets, :min)
offset_maxes = scaling.call(formant_offsets, :max)
offset_ranges = offset_maxes - offset_mins

slope_mins = scaling.call(formant_slopes, :min)
slope_maxes = scaling.call(formant_slopes, :max)
slope_ranges = slope_maxes - slope_mins

scaled_offsets = (formant_offsets - offset_mins) / offset_ranges
scaled_slopes = (formant_slopes - slope_mins) / slope_ranges

scaled_formants = @formant_lines.map(&:last).to_nm

@formant_repeats = (0..30).map do |i|
  scale_factor = Math.cos((Math::PI / 30.0) * i)
  [scaled_offsets, scaled_slopes * scale_factor]
end

@formant_repeats = @formant_repeats.dup.map do |repeat|
  repeat.first.to_a.zip(repeat.last.to_a).map do |offset_slope|
    {:offset => offset_slope[0], :slope => offset_slope[1]}
  end
end

# Read in the existing stuff
File.open "scaled_formant_repeats.json", "r" do |f|
  @formant_repeats = JSON.parse(f.read, :symbolize_names => true)
end

@notenames = ["f", "g", "a", "b", "c'", "d'", "e'", "f'", "g'"] 
quantizer = ->(offset) { (offset * 8).round } 

@formant_repeats.each do |fr|
  fr.each do |f|
    f[:quant_offset] = f[:offset].map(&quantizer)
  end
end

@formant_repeats.each do |fr|
  fr.each do |f|
    f[:quant_slope] = f[:slope].map {|r| r.round(1)}
  end
end

@formant_repeats.each do |fr|
  fr.each do |f|
    f[:lily_offset] = f[:quant_offset].map {|r| @notenames[r]}
  end
end

# Save to a file
File.open "finished_formant_repeats.json", "w" do |f|
  f.puts JSON.pretty_generate(@formant_repeats)
end

@formant_repeats.each do |fr|
  fr.zip(@formant_lines).each do |f|
    f[0][:num_frames] = f[1][0]
  end
end


