\version "2.19.15"

\include "./acs_house_style.ly"
\include "./helmholtz_ellis.ly"
\include "./straight_bends.ly"
\include "./pitch_first_half.ly"
\include "./formant_first_half.ly"
\include "./pitch_second_half.ly"
\include "./formant_second_half.ly"

\header {
  composer = "Andrew C. Smith"
  title = \markup \sans { "In the sense of transparence" }
  subtitle = "On a poem by George Oppen, written for Séverine Ballon"
  tagline = ""
}

words_first_half = \lyricmode {
  ob -- sessed be -- wil -- dered 
  by the ship -- wreck of the sin -- gu -- lar
  we have cho -- sen the mean -- ing of being num -- er -- ous
}

words_second_half = \lyricmode {
  clar -- i -- ty
  in the sense of trans -- par -- ence
  I don't mean that much can be ex -- plained
  clar -- i -- ty in the sense of si -- lence
}

\paper {
  #(set-paper-size "letter" 'landscape)

  top-markup-spacing = 
  #'((basic-distance . 16)
    (minimum-distance . 16)
    (padding . 2)
    (stretchability . 12))

  score-system-spacing = 
  #'((basic-distance . 24)
    (minimum-distance . 16)
    (padding . 2)
    (stretchability . 12))

  markup-system-spacing = 
  #'((basic-distance . 24)
    (minimum-distance . 16)
    (padding . 2)
    (stretchability . 12))

  system-system-spacing = 
  #'((basic-distance . 12)
    (minimum-distance . 8)
    (stretchability . 12)
    (padding . 1))

  max-systems-per-page = #5

  #(define fonts
    (set-global-fonts
      #:music "emmentaler-he"
      #:roman "OFL Sorts Mill Goudy"
      #:sans "League Spartan"
      #:factor (/ staff-height pt 20)))
}

\markup \column { % Performance notes
  \vspace #4
  \line { \large \sans {Performance notes} }
  \line { \musicglyph #"noteheads.s2cross" = mute string with flats of fingers }
  \line { \musicglyph #"scripts.sforzato" = accents should be very subtle, light }
  \line { \musicglyph #"scripts.rcomma" = short pause }
  \vspace #1
  \wordwrap { Only sustain the notes while there is a bow position marking below
    the indicated pitch. Rhythm should be taken from the speech of the poem in a
    provided mp3. The text printed within the system should be indicative of the
    speech rhythm, but the text itself should not be spoken. It is only there to
    assist in learning the rhythm, and where the accents line up with the
    recording.}
  \vspace #2
  \line { \large \sans { Tuning key } }
  \line \sans { Helmholtz-Ellis accidentals, by Marc Sabat and Wolfgang Von Schweinitz }
}

\score { % Tuning key
  \new Staff {
    \clef bass
    \time 8/4
    dDe4_\markup \sans {-49.4}^\markup \sans {\small 12/11}
    dUs_\markup {\sans "+31.2"}^\markup \sans {\small 8/7}
    eflatDs_\markup {\sans "-33.1"}^\markup \sans {\small 7/6}
    eflatUf_\markup {\sans "+15.6"}^\markup \sans {\small 6/5}
    eDf_\markup {\sans "-13.7"}^\markup \sans {\small 5/4}
    eUs_\markup {\sans "+31.2"}^\markup \sans {\small 9/7}
    fDsDe_\markup {\sans "-82.5"}^\markup \sans {\small 14/11}
    fsharpDfUs_\markup {\sans "+17.5"}^\markup \sans {\small 10/7} \break |
    gflatUfDs_\markup {\sans "-17.5"}^\markup \sans {\small 7/5}
    gUsUe_\markup {\sans "+82.5"}^\markup \sans {\small 11/7}
    aflatDs_\markup {\sans "-31.2"}^\markup \sans {\small 5}
    aflatUf_\markup {\sans "+13.7"}^\markup \sans {\small 8/5}
    aDf_\markup {\sans "-15.6"}^\markup \sans {\small 5/3}
    aUs_\markup {\sans "+33.1"}^\markup \sans {\small 12/7}
    bflatDs_\markup {\sans "-31.2"}^\markup \sans {\small 7/4}
    bflatUf_\markup {\sans "+17.6"}^\markup \sans {\small 9/5} \break |
  }

  \layout {
    indent = 0\cm
    short-indent = 0\cm

    \context {
      \Voice
      \remove "Stem_engraver"
    }
    \context {
      \Score
      proportionalNotationDuration = #(ly:make-moment 1 24)
      \remove "Bar_number_engraver"
    }
    \context {
      \Staff
      \remove "Time_signature_engraver"
    }
  }
}

\pageBreak

\score { 
  <<
  \new Staff \with {
    \remove "Ledger_line_engraver"
    \remove "Clef_engraver"
    instrumentName = \markup \concat \vcenter {"Bow pos." \hspace #1 \smaller \column {"pont." "tasto"}}
  } {
    \clef percussion
    \override Staff.StaffSymbol.line-positions = #'(-4 0 4)
    \override BendAfter.stencil = #straight-bend::print
    \override NoteHead.transparent = ##t

    \formant_first_half
    \formant_second_half
    \bar "|." |
    
  }
  \new Staff \with {
    instrumentName = "Pitch"
  } {
    \new Voice = "pitches" {
      #(set-accidental-style 'forget)
      \time 12/4
      \clef bass
      \tempo \markup \sans {"11-12 seconds per line, at the rhythm of speech"}
      
      \pitch_first_half
      \pitch_second_half
      \bar "|." |
    }
  }
  \new Lyrics \lyricsto "pitches" {
    \override LyricText.font-size = #-1.0
    \override LyricText.font-shape = #'italic
    \repeat unfold 31 {\words_first_half}
    \repeat unfold 31 {\words_second_half}
  }
  >>
  
  \layout {
    indent = 4\cm
    \override DynamicText.font-name = #"League Spartan Bold"
    \context {
      \Score
      proportionalNotationDuration = #(ly:make-moment 1 32)
    }
    \context {
      \Voice
      \remove "Stem_engraver"
    }
    \context {
      \Staff
      \remove "Time_signature_engraver"
    }
  }
}

