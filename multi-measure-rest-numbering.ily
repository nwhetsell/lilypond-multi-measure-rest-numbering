\version "2.24.0"

#(define (Multi_measure_rest_numbering_engraver context)
  (let (
      (end-event #f)
      (left-number #f)
      (spanner #f)
      (start-event #f))

    (make-engraver
      (listeners
        ((multi-measure-rest-event engraver event)
          (if start-event
            (set! end-event event)
          ; else
            (set! start-event event)))
        ((note-event engraver event)
          (set! end-event event))
        ((rest-event engraver event)
          (set! end-event event)))

      ((process-music engraver)
        (when (and start-event (not spanner))
          (set! left-number (ly:context-property context 'currentBarNumber))
          (set! end-event #f)
          (set! spanner (ly:engraver-make-spanner engraver 'MeasureCounter start-event))
          (ly:grob-set-property! spanner 'direction DOWN)
          (ly:grob-set-property! spanner 'font-encoding 'latin1)
          (ly:grob-set-property! spanner 'font-features '("pnum"))
          (ly:grob-set-property! spanner 'left-number-text (number->string left-number))
          (ly:spanner-set-bound! spanner LEFT (ly:context-property context 'currentCommandColumn)))
        (when (and end-event spanner)
          (let ((right-number (- (ly:context-property context 'currentBarNumber) 1)))
            (if (> right-number left-number)
              (begin
                (ly:grob-set-property! spanner 'right-number-text (number->string right-number))
                (ly:spanner-set-bound! spanner RIGHT (ly:context-property context 'currentCommandColumn)))
            ; else
              (ly:grob-suicide! spanner)))
          (set! end-event #f)
          (set! left-number #f)
          (set! start-event #f)
          (set! spanner #f))))))

\layout {
  \context {
    \DrumStaff
    \consists #Multi_measure_rest_numbering_engraver
  }
  \context {
    \Staff
    \consists #Multi_measure_rest_numbering_engraver
  }
}
