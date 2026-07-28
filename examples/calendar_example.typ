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

#let non-recurring = (
    (9, 20, "project #1"),
    (10, 11, "project #2"),
    ("November", 1, "project #3"),
    (11, 22, "project #4"),

    (9, 18, "QUIZ #1"),
    (10, 16, "MIDTERM"),
    (11, 13, "QUIZ #2"),
    (12, 11, "FINAL"),
)

#let zy = calendars.construct-recurring-dates(
    ("aug", 30),
    11,
    "zyBooks",
    dates-to-skip: (10, 18)
)

#let lab = calendars.construct-recurring-dates(
    ("aug", 30),
    12,
    "lab",
    dates-to-skip: (10, 18)
)
#let due-dates = non-recurring + zy + lab

#let holiday-encodings = ((
    (9, 7),
    ("nov", 11),
    (11, 25),
    (11, 26),
    (11, 27)
    ),
    gray
)

#let finals-encodings = ((
    (12, 7),
    (12, 8),
    ("dec", 9),
    (12, 10),
    ("december", 11)
    ),
    rgb("#f59998")
)

#let shading-encodings = (
    holiday-encodings,
    finals-encodings
)

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



