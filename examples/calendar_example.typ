#import "../src/calendars.typ"

#show: calendars.init

#let color-coding = (
    ("zyBooks", rgb("#10a178")),
    ("lab", rgb("#104fa1")),
    ("proj", rgb("#a19e10")),
    ("QUIZ", rgb("#a15d10")),
    ("exam", rgb("#a11010")),
    ("FINAL", rgb("#a11010")),
    ("MIDTERM", rgb("#a11010"))
)

#let non-recurring = (
    (9, 2, "proj #1 opens"),
    (9, 20, "proj #1 due"),
    (9, 23, "proj #2 opens"),
    (10, 18, "proj #2 due"),
    (10, 21, "proj #3 opens"),
    ("November", 8, "proj #3 due"),
    (11, 11, "proj #4 opens"),
    (11, 29, "proj #4 due"),

    (9, 16, "QUIZ #1"),
    (10, 9, "MIDTERM"),
    (11, 4, "QUIZ #2"),
    (12, 11, "FINAL"),
)

#let zy = calendars.construct-recurring-dates(
    ("aug", 30),
    11,
    "zyBooks",
    dates-to-skip: ((9, 6), (11, 15))
)

#let lab = calendars.construct-recurring-dates(
    ("sep", 6),
    12,
    "lab",
    dates-to-skip: ((10, 18), (11, 29))
)
#let due-dates = zy + lab + non-recurring

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
    (7, "MIDTERM WEEK"),
    (8, "GUI"),
    (9, "GUI"),
    (10, "RECURSION"),
    (11, "RECURSION"),
    (12, "SEARCHING, SORTING, THREADING"),
    (13, "THREADING"),
    (14, "THANKSGIVING BREAK"),
    (15, "CATCH-UP, INSTRUCTOR CHOSEN, REVIEW"),
    (16, "FINALS WEEK")
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
