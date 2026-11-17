\version "2.24.0"

\include "multi-measure-rest-numbering.ily"

\relative {
  c'4 e g c |
  R1*42
  \mark \default
  R1
  c4 g e c |
}

\layout {
  \context {
    \Score
    skipBars = ##t
  }
  \context {
    \Staff
    \consists #Multi_measure_rest_numbering_engraver
  }
}
