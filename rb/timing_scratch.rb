def round_timings interval
  if interval.respond_to? :rounded_max
    interval.rounded_max = interval.xmax.round(2).rationalize
    interval.rounded_min = interval.xmin.round(2).rationalize
  else
    interval.add_property(:rounded_max, interval.xmax.round(2).rationalize)
    interval.add_property(:rounded_min, interval.xmin.round(2).rationalize)
  end
end

syllable.items[0].intervalss.each do |interval|
  round_timings interval
end

def add_duration interval
  if interval.respond_to? :rounded_dur
    interval.rounded_dur = interval.rounded_max - interval.rounded_min
  else
    interval.add_property(:rounded_dur, interval.rounded_max - interval.rounded_min)
  end
end

syllable.items[0].intervalss.each do |interval|
  add_duration interval
end

durations = syllable.items[0].intervalss.map do |interval|
  {:duration_string => interval.rounded_dur.to_s,
   :rest => interval.text.empty?}
end

File.open "durations_s7.json", "w" do |f|
  f.puts JSON.pretty_generate(durations)
end

pr = @pitch_repeats.map do |repeat|
  repeat = repeat.dup
  durations.map do |dur|
    if dur[:rest]
      note = "r"
    else
      n = repeat.shift
      note = n ? n[:lily_note] : "\\\once \\\override NoteHead.style = \#'cross \\nc"
    end
    note + "4*" + dur[:duration_string]
  end << "r8 |"
end

pr = pr.map {|x| x.join(" ")}.join("\\n\\n")
File.open "pitch_first_half.ly", "w" do |f|
  f << 'pitch_first_half = {'
  f << pr
  f << '}'
end


@formant_repeats.map do |repeat|
  repeat = repeat.dup
  durations.map do |dur|
    if dur[:rest]
      note = "s"
    else
      n = repeat.shift
      note = n[:lily_offset][0]
    end
    note = note + "4*" + dur[:duration_string]
    unless dur[:rest]
      note = note + " \\\bendAfter \#" + (n[:quant_slope][0] * n[:num_frames] * 3.0 / 70.0).round(1).to_s
    end
    note
  end << "s8 |"
end

