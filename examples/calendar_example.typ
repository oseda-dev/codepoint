#import "../src/calendars.typ"

#show: calendars.init

#let color-coding = (
    ("zyBooks", rgb("#10a178")),
    ("lab", rgb("#104fa1")),
    ("project", rgb("#a19e10")),
    ("QUIZ", rgb("#a15d10")),
    ("exam", rgb("#a11010")),
    ("FINAL", rgb("#a11010")),
    ("MIDTERM", rgb("#a11010"))
)

#let due-dates = (
    (8, 30, "zyBooks #1"),
    (9, 6, "zyBooks #2"),
    (9, 13, "zyBooks #3"),
    (9, 20, "zyBooks #4"),
    (9, 27, "zyBooks #5"),
    ("oct", 4, "zyBooks #6"),
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
    ("November", 1, "project #3"),
    (11, 22, "project #4"),

    (9, 18, "QUIZ #1"),
    (10, 16, "MIDTERM"),
    (11, 13, "QUIZ #2"),
    (12, 11, "FINAL"),

    (9,9, "project #1"),
    (9,9, "QUIZ #1"),
    (9,9, "lab #8"),
)

#let holidays = (
    (9, 7),
    ("nov", 11),
    (11, 25),
    (11, 26),
    (11, 27)
)

#let finals-week = (
    (12, 7),
    (12, 8),
    ("dec", 9),
    (12, 10),
    ("december", 11)
)

#let test = (("september", 23), blue)

#let holiday-encodings = (holidays, gray)
#let finals-encodings = (finals-week, rgb("#f59998"))

#let shading-encodings = (
    holiday-encodings,
    finals-encodings
)

#let test2 = ("nov", 5, "BLAH")

#let overviews = (
    (1, "INTRO AND OOP REVIEW"),
    (2, "CONTINUED REVIEW, ABSTRACT CLASSES, INTERFACES"),
    (3, "DYNAMIC DISPATCH, INNER CLASSES, LAMBDAS"),
    (4, "GENERICS"),
    (5, "GENERICS, COLLECTIONS, LIST, ADT INTRO"),
    (6, "ADTS, LISTS, STACKS, QUEUES, MAPS, SETS"),
    (7, "GUI"),
    (9, "GUI"),
    (10, "RECURSION"),
    (11, "RECURSION"),
    (12, "SEARCHING, SORTING, THREADING"),
    (13, "THREADING"),
    (15, "CATCH-UP, INSTRUCTOR CHOSEN, REVIEW"),
)

#calendars.draw-calendar(
    ("aug", "dec"),
    (23, 12),
    title: "CS-1181 FA26",
    color-codes: color-coding,
    shading: shading-encodings,
    due-dates: due-dates,
    week-overviews: (overviews, rgb("#305e61")),
)
