#import "@preview/codepoint:0.2.1":labs
#import "../src/calendars.typ"

#show: calendars.init

#let color-coding = (
    ("zyBooks", rgb("#10a178")),
    ("lab", rgb("#104fa1")),
    ("project", rgb("#a19e10")),
    ("quiz", rgb("#a15d10")),
    ("exam", rgb("#a11010")),
    ("final", rgb("#a11010"))
)



#calendars.header(
    (8, 12),
    (23, 12),
    title: "CS-1181 FA26",
    color-codes: color-coding
)

nsddsssssddddddxdddjdss