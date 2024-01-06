# lilypond-multi-measure-rest-numbering

You can use the file [multi-measure-rest-numbering.ily](multi-measure-rest-numbering.ily) in this repository with LilyPond v2.24.0 or later to put bar numbers beneath multi-measure rests. For example, running:

```sh
lilypond --output=multi-measure-rest-numbering --svg - <<EOS
\version "2.24.0"
\include "multi-measure-rest-numbering.ily"
\paper {
  page-breaking = #ly:one-line-auto-height-breaking
  top-margin = 0
  left-margin = 0
  right-margin = 0
  oddFooterMarkup= ##f
}
\pointAndClickOff
\relative {
  \startMeasureCount
  c'4 e g c |
  R1*42
  \mark \default
  R1
  c4 g e c |
  \stopMeasureCount
}
\layout {
  \context { \Score skipBars = ##t }
}
EOS
```

will output:

<img src="multi-measure-rest-numbering.svg">
