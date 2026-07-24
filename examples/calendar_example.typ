#import "@preview/codepoint:0.2.1":labs
#import "../src/calendars.typ"

#show: calendars.init

#let color-coding = (
    ("zyBooks", rgb("#10a178")),
    ("lab", rgb("#104fa1")),
    ("project", rgb("#a19e10")),
    ("QUIZ", rgb("#a15d10")),
    ("exam", rgb("#a11010")),
    ("FINAL", rgb("#a11010")),
    ("MIDTERM", rgb("#a11010")),
)

#let holidays = (
    (9, 7),
    (11, 11),
    (11, 25),
    (11, 26),
    (11, 27)
)

#let finals-week = (
    (12, 7),
    (12, 8),
    (12, 9),
    (12, 10),
    (12, 11)
)

#let holiday-encodings = (holidays, gray)
#let finals-encodings = (finals-week, rgb("#f59998"))

#let shading-encodings = (
    holiday-encodings,
    finals-encodings
)

#let due-dates = (
    (8, 30, "zyBooks #1"),
    (9, 6, "zyBooks #2"),
    (9, 13, "zyBooks #3"),
    (9, 20, "zyBooks #4"),
    (9, 27, "zyBooks #5"),
    (10, 4, "zyBooks #6"),
    (10, 11, "zyBooks #7"),
    (10, 18, "zyBooks #8"),
    (10, 25, "zyBooks #9"),
    (11, 1, "zyBooks #10"),
    (11, 8, "zyBooks #11"),

    (8, 30, "lab #1"),
    (9, 6, "lab #2"),
    (9, 13, "lab #3"),
    (9, 20, "lab #4"),
    (9, 27, "lab #5"),
    (10, 4, "lab #6"),
    (10, 11, "lab #7"),
    (10, 18, "lab #8"),
    (10, 25, "lab #9"),
    (11, 1, "lab #10"),
    (11, 8, "lab #11"),
    (11, 15, "lab #12"),

    (9, 20, "project #1"),
    (10, 11, "project #2"),
    (11, 1, "project #3"),
    (11, 22, "project #4"),

    (9, 18, "QUIZ #1"),
    (10, 16, "MIDTERM"),
    (11, 13, "QUIZ #2"),
    (12, 11, "FINAL"),
)



#calendars.header(
    (8, 12),
    (23, 12),
    title: "CS-1181 FA26",
    color-codes: color-coding,
    shading: shading-encodings,
    due-dates: due-dates,
)