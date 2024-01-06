\version "2.24.0"

#(define (Multi_measure_rest_numbering_engraver context)
  (let (
      (measure-counters '()))

    (make-engraver
      (acknowledgers
        ((measure-counter-interface engraver grob source-engraver)
          (set! measure-counters (cons grob measure-counters))))

      ((finalize engraver)
        (for-each
          (lambda (measure-counter)
            (when (null? (ly:grob-property measure-counter 'right-number-text))
              (ly:grob-suicide! measure-counter)))
          measure-counters)))))

\layout {
  \context {
    \Staff
    \consists Measure_counter_engraver
    \override MeasureCounter.direction = #DOWN
    \override MeasureCounter.font-encoding = #'latin1
    \override MeasureCounter.font-features = #'("pnum")
    \consists #Multi_measure_rest_numbering_engraver
  }
}
