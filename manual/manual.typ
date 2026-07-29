// run me from root directory with
// `typst compile --root . manual/manual.typ`

#import "@preview/tidy:0.4.3"

#let exam-docs = tidy.parse-module(
  read("/src/exams.typ"), 
  label-prefix: "exams-" // avoid name collisions
)
#let lab-docs = tidy.parse-module(
  read("/src/labs.typ"),
  label-prefix: "labs-" // avoid name collisions 
)
#let calendar-docs = tidy.parse-module(
  read("/src/calendars.typ"),
  label-prefix: "calendars-" // avoid name collisions
)

= Exams Module 
#tidy.show-module(exam-docs, style: tidy.styles.default)

#pagebreak()

= Labs Module
#tidy.show-module(lab-docs, style: tidy.styles.default)

#pagebreak()

= Calendars Module
#tidy.show-module(calendar-docs, style: tidy.styles.default)
