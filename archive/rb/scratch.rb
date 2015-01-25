# tuneable by ear only
[[1,1], [8,7], [7,6], [6,5], [5,4], [9,7], [13,10], [4,3], [7,5], [10,7], [3,2], [11,7], [8,5], [13, 8], [5, 3], [12, 7], [7, 4], [9, 5], [11, 6], [13, 7], [2, 1]]

def available_pitches step, rd, max_prime = nil
  if max_prime
    rd = rd.select do |ratio|
      ratio[:prime_limit] <= max_prime
    end
  end

  min_harmonicity = Math.sin(step * Math::PI/30)

  if min_harmonicity == 0
    rd.select {|ratio| ratio[:ratio] == [1, 1]}
  elsif min_harmonicity < 0
    r = Range.new(-1.0, -1.0 - min_harmonicity)
    rd.select {|ratio| r.include? ratio[:harmonicity]}
  else
    r = Range.new(1.0 - min_harmonicity, 1.0)
    rd.select {|ratio| r.include? ratio[:harmonicity]}
  end
end

def quantize pitch, values
  if pitch[:pitch].nil?
    nil
  else
    values.min_by {|q| (pitch[:pitch] - q[:pitch_height]).abs}
  end
end

# Read in the tuneable interval data and add the inversions
File.open "tuneable_intervals.json", "r" do |tu|
  @ratio_data = JSON.parse(tu.read, :symbolize_names => true)
end

@ratio_data.dup.each do |rd|
  @ratio_data << {
    :ratio => [rd[:ratio][1], rd[:ratio][0]],
    :harmonicity => rd[:harmonicity] * -1.0,
    :pitch_height => rd[:pitch_height] * -1.0
  }
end

# Add the prime_limit to the ratios
@ratio_data.each do |ratio|
  ratio[:prime_limit] = ratio[:ratio].max_by do |num|
    a = num.prime_division.map(&:first).max
    a.nil? ? 0 : a
  end

  unless ratio[:prime_limit] == 1
    ratio[:prime_limit] = ratio[:prime_limit].prime_division.last.first
  end
end

File.open "vowel_pitches.json", "r" do |vp|
  @vowel_pitches = JSON.parse(vp.read, :symbolize_names => true)
end

# Quantize the pitch_repeats to 11-limit
File.open("pitch_repeats.json", "w") do |f|
  @pitch_repeats = (0..60).map do |i|
    a = available_pitches i, Marshal.load(Marshal.dump(@ratio_data)), 13
    @vowel_pitches.map {|p|
      quantize p, a
    }
  end
  f.puts(JSON.pretty_generate(@pitch_repeats))
end

# Read it in again!
File.open "pitch_repeats.json", "r" do |f|
  @pitch_repeats = JSON.parse(f.read, :symbolize_names => true)
end

@pitch_repeats = @pitch_repeats[0..30]

ly = MM::Lilypond.new
ly.offset = 0

@pitch_repeats.each do |pr|
  pr.each do |pitch|
    unless pitch.nil?
      pitch[:lily_note] = ly.get_pitch(MM::Ratio.new(*pitch[:ratio]))
    end
  end
end

