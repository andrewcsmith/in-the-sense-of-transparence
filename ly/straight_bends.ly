#(define-public (straight-bend::print spanner)
  (define (close  a b)
    (< (abs (- a b)) 0.01))

  (let* ((delta-y (* 0.5 (ly:grob-property spanner 'delta-position)))
         (left-span (ly:spanner-bound spanner LEFT))
         (dots (if (and (grob::has-interface left-span 'note-head-interface)
                        (ly:grob? (ly:grob-object left-span 'dot)))
                   (ly:grob-object left-span 'dot) #f))

         (right-span (ly:spanner-bound spanner RIGHT))
         (thickness (* (ly:grob-property spanner 'thickness)
                       (ly:output-def-lookup (ly:grob-layout spanner)
                                             'line-thickness)))
         (padding (ly:grob-property spanner 'padding 0.5))
         (common (ly:grob-common-refpoint right-span
                                          (ly:grob-common-refpoint spanner
                                                                   left-span X)
                                          X))
         (common-y (ly:grob-common-refpoint spanner left-span Y))
         (minimum-length (ly:grob-property spanner 'minimum-length 0.5))

         (left-x (+ padding
                    (max
                     (interval-end (ly:generic-bound-extent
                                    left-span common))
                     (if
                      (and dots
                           (close
                            (ly:grob-relative-coordinate dots common-y Y)
                            (ly:grob-relative-coordinate spanner common-y Y)))
                      (interval-end
                       (ly:grob-robust-relative-extent dots common X))
                      (- INFINITY-INT)))))
         (right-x (max (- (interval-start
                           (ly:generic-bound-extent right-span common))
                          padding)
                       (+ left-x minimum-length)))
         (self-x (ly:grob-relative-coordinate spanner common X))
         (dx (- right-x left-x)))

    (make-line-stencil
      0.3
      0
      0
      dx 
      delta-y
      )))

