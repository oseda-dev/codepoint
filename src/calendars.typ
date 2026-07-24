#let months = (
    ("January", 31),
    ("February", 28),
    ("March", 31),
    ("April", 30),
    ("May", 31),
    ("June", 30),
    ("July", 31),
    ("August", 31),
    ("September", 30),
    ("October", 31),
    ("November", 30),
    ("December", 31)
)

#let day-arr = (
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
)

/// Initialize a lab with a show rule
///
///
/// Example:
/// ```typst
/// #show: labs.init
/// ```
/// - body (content): body fo lab problem
#let init(body) = {

  assert(
    type(body) == content or type(body) == str,
    message: "Expected body to be content or str, but received" + str(type(body))
  )


  set page(margin: 20pt, width: 8.5in, height: auto)
  set text(
    font: ("Roboto"),
    size: 11pt,
    fill: black,
    weight: "regular"
  )
  set raw(theme: "../themes/codepoint.tmTheme")
  show raw: set text(font: ("Courier", "Courier Prime"), weight: "bold", size: 10pt)

  // defaults to 1.2, but on labs specifically, this is not enough spacing
  set par(spacing: 1.6em)

  body
}

#let days-of-week(is-mon-start: false) = {
    let days = day-arr
    if is-mon-start {
        let old = days.remove(0)
        days.push("Sunday")
    }

    table(
        columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
        align: center,
        stroke: none,
        ..days.flatten()
    )
}

#let month-header(month-id, is-mon-start: false) = {
  assert(
    type(month-id) == int,
    message: "Expected month-id to be int, but received" + str(type(month-id))
  )

  v(-10pt)
  text[== #months.at(month-id).at(0)]
  line(length: 100%, stroke: 1pt)
  v(-15pt)
  days-of-week(is-mon-start: is-mon-start)
  v(-15pt)
  line(length: 100%, stroke: 1pt)
}

#let construct-day-arr(month-id, start, last-month-max, last-week-num, is-leap-year: false) = {
    let max-days = months.at(month-id).at(1)

    if last-month-max != none {
        max-days = last-month-max
    }

    if is-leap-year and month-id == 1 {
        max-days = max-days + 1;
    }

    let day-nums = ()
    let day = start
    let reach-max = false
    let week-count = last-week-num

    while calc.rem(day-nums.len(), 8) != 0 or not reach-max {
        if calc.rem(day-nums.len(), 8) == 0 {
            day-nums.push("week #" + str(week-count))
            week-count = week-count + 1
        }
        day-nums.push(str(day))

        day = day + 1
        if day > max-days {
            day = 1
            reach-max = true
        }
    }
    return (day-nums, week-count)
}

#let construct-month-table(days, keywords) = {
    v(-18pt)

    show table.cell: it => {
        // matchs to the text "week #" followed by a one or two digit number
        // rotates and bolds the text
        show regex("week #\d{1,2}"): it => text(size:11pt, weight: "bold")[#rotate(-90deg, reflow: true)[#v(-20pt)#it]]
        it
    }
    table(
        columns: (0fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
        align: center,
        rows: 60pt,
        ..days.map(text-str => {
            let all-pieces = text-str.split("-")
            if all-pieces.len() == 1 {
                table.cell()[#text-str]
            } else {
                let num = all-pieces.at(0)
                let temp = []
                let content = text(weight: "bold")[#num]
                let i = 1
                while i < all-pieces.len() {
                    temp = all-pieces.at(i)
                    let j = 0
                    while j < keywords.len() {
                        if temp.contains(keywords.at(j).at(0)) {
                            temp = text(fill: keywords.at(j).at(1))[#temp]
                            break
                        }
                        j = j + 1
                    }
                    content = content + align(left)[#v(-10pt)#temp]
                    i = i + 1
                }
                table.cell()[#content]
            }
            //table.cell(fill: if text-str.contains("exam") { rgb("#a12310").lighten(40%) } else { none })[#text(fill: if text-str.contains("exam") { rgb("#a12310") } else { black })[#text-str]]
        })
        //..days.flatten()
    )
}

/// header: Render the document section header block for lab problems
/// - startMonth (content, str): Class name
/// - title (content, str): The title text for the specific lab problem
/// - number (int, string, none): Lab problem number, if applicable
#let header(month-range, day-range, title:none, is-leap-year:false, is-mon-start:false, color-codes:none) = {
    assert(
        type(month-range) == array,
        message: "Expected month-range to be array, but received " + str(type(month-range))
    )

    assert(
        type(month-range.at(0)) == int,
        message: "Expected month-range to be array of int, but received " + str(type(month-range.at(0)))
    )

    assert(
        type(month-range.at(1)) == int,
        message: "Expected month-range to be array of int, but received " + str(type(month-range.at(1)))
    )

    assert(
        month-range.at(1) > 0 and month-range.at(1) < 13,
        message: "Second month-range value must be >0 and <13"
    )

    assert(
        month-range.at(0) > 0 and month-range.at(0) < month-range.at(1),
        message: "First month-range value must be >0 and <" + str(month-range.at(1))
    )

  assert(
    type(day-range) == array,
    message: "Expected day-range to be array, but received " + str(type(day-range))
  )

  assert(
    type(day-range.at(0)) == int,
    message: "Expected day-range to be array of int, but received " + str(type(day-range.at(0)))
  )

  assert(
    type(day-range.at(1)) == int,
    message: "Expected day-range to be array of int, but received " + str(type(day-range.at(1)))
  )

  assert(
      day-range.at(0) > 0 and day-range.at(0) < 32 and day-range.at(1) > 0 and day-range.at(1) < 32,
      message: "Day-range values must be >0 and <32"
  )

  assert(
    type(title) == str or title == none,
    message: "Expected title to be string, or none, but received " + str(type(title))
  )

    assert(
        type(is-leap-year) == bool or is-leap-year == none,
        message: "Expected is-leap-year to be bool, or none, but received " + str(type(is-leap-year))
    )

    assert(
        type(is-mon-start) == bool or is-mon-start == none,
        message: "Expected is-mon-start to be bool, or none, but received " + str(type(is-mon-start))
    )

  if title != none {
      text[= #title]
      line(length: 100%, stroke: 2pt)
      v(5pt)
  }

  let month = month-range.at(0) - 1
  let start-day = day-range.at(0)
  let days = (none, 1)
  let end-day = none

  while month < month-range.at(1) {
    // if we are at the last month,
    // set the end-day the user requested
    if month == month-range.at(1) - 1 {
        end-day = day-range.at(1)
    }

  	month-header(month, is-mon-start: is-mon-start)
    days = construct-day-arr(month, start-day, end-day, days.at(1), is-leap-year: is-leap-year)
    construct-month-table(days.at(0), color-codes)

    start-day = int(days.last()) + 1
    // prevents starting a month on 32 or another not real day
    if start-day > 10 {
        start-day = 1
    }
  	month = month + 1
  }

    v(50pt)
    // [1#align(left)[#v(-10pt)Exam \#1]]
    days = ("week #1", "1-exam #1", "1-zyBooks #1-lab #1")
    construct-month-table(days, color-codes)
}


