\version "2.24.0"

#(define (Multi_measure_rest_numbering_engraver context)
  (let (
      (left-number #f)
      (mmrest-end-event #f)
      (mmrest-event #f)
      (text-grob #f))

    (make-engraver
      (listeners
        ((multi-measure-rest-event engraver event)
          (if mmrest-event
            (set! mmrest-end-event event)
          ; else
            (set! mmrest-event event)))
        ((note-event engraver event)
          (set! mmrest-end-event event))
        ((rest-event engraver event)
          (set! mmrest-end-event event)))

      ((process-music engraver)
        (when (and mmrest-event (not text-grob))
          (set! left-number (ly:context-property context 'currentBarNumber))
          (set! mmrest-end-event #f)
          (set! text-grob (ly:engraver-make-grob engraver 'TextScript mmrest-event))
          (ly:grob-set-property! text-grob 'font-features '("pnum"))
          (ly:grob-set-property! text-grob 'font-size -2)
          (ly:grob-set-property! text-grob 'outside-staff-horizontal-padding 0.5)
          (ly:grob-set-property! text-grob 'outside-staff-priority 750)
          (ly:grob-set-property! text-grob 'padding 0.2))
        (when (and mmrest-end-event text-grob)
          (let ((right-number (- (ly:context-property context 'currentBarNumber) 1)))
            (if (> right-number left-number)
              (ly:grob-set-property! text-grob 'text (format #f "~d–~d" left-number right-number))
            ; else
              (ly:grob-suicide! text-grob)))
          (set! left-number #f)
          (set! mmrest-end-event #f)
          (set! mmrest-event #f)
          (set! text-grob #f))))))

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
