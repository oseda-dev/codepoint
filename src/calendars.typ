#let month-days = (
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

#let month-inputs = (
    ("january", "jan"),
    ("february", "feb"),
    ("march", "mar"),
    ("april", "apr"),
    ("may",),
    ("june", "jun"),
    ("july", "jul"),
    ("august", "aug"),
    ("september", "sep"),
    ("october", "oct"),
    ("november", "nov"),
    ("december", "dec"),
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
    show raw: set text(font: ("Courier"), weight: "bold", size: 10pt)

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
    text[== #month-days.at(month-id).at(0)]
    line(length: 100%, stroke: 1pt)
    v(-15pt)
    days-of-week(is-mon-start: is-mon-start)
    v(-15pt)
    line(length: 100%, stroke: 1pt)
}

#let construct-day-arr(month-id, start, last-month-max, last-week-num, is-leap-year: false, shading:(), assigns:()) = {
    // number of days in the month
    let max-days = month-days.at(month-id).at(1)

    // override if different last day is provided
    if last-month-max != none {
        max-days = last-month-max
    }

    // account for leap year
    if is-leap-year and month-id == 1 {
        max-days = max-days + 1;
    }

    let day-nums = ()
    let day = start
    let reach-max = false
    let week-count = last-week-num

    // loops until the month max has been reached
    // AND the week has been completed
    while calc.rem(day-nums.len(), 8) != 0 or not reach-max {
        // inserts the week # tag at the beginning of each week
        if calc.rem(day-nums.len(), 8) == 0 {
            day-nums.push("week #" + str(week-count))
            week-count = week-count + 1
        }

        let i = 0
        let day-text = str(day)
        while i < shading.len() {
            let j = 0
            let dates = shading.at(i)
            while j < dates.len() {
                let date = dates.at(j)
                if (date.at(0) == (month-id + 1)) and (date.at(1) == day) {
                    day-text = day-text + "-" + str(i)
                    break
                }
                j = j + 1
            }
            i = i + 1
        }

        i = 0
        while i < assigns.len() {
            let item = assigns.at(i)
            if (item.at(0) == (month-id + 1)) and (item.at(1) == day) {
                day-text = day-text + "-" + item.at(2)
            }
            i = i + 1
        }

        // inserts the day number
        day-nums.push(day-text)

        day = day + 1
        // resets day if the max is reached
        if day > max-days {
            day = 1
            reach-max = true
            month-id = month-id + 1
        }
    }
    return (day-nums, week-count, day)
}

#let construct-month-table(days, keywords, shading-colors) = {
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
        rows: 70pt,
        ..days.map(text-str => {
            let all-pieces = text-str.split("-")
            // if there is only a number
            if all-pieces.len() == 1 {
                table.cell()[#text(weight: "bold")[#text-str]]
            } else {
                let fill-color = none
                let num = all-pieces.at(0)
                let temp = []
                let content = text(weight: "bold")[#num]
                let skip = false
                let i = 1
                while i < all-pieces.len() {
                    skip = false
                    temp = all-pieces.at(i)
                    // checks if the cell should be shaded
                    let shade-id = 0
                    while shade-id < shading-colors.len() {
                        if temp == str(shade-id) {
                            fill-color = shading-colors.at(shade-id)
                            skip = true
                        }
                        shade-id = shade-id + 1
                    }

                    // only need to check for keywords if we determine it is not a shading key
                    if skip == false {
                        // check all keywords and perform color coding as needed
                        let j = 0
                        while j < keywords.len() {
                            if temp.contains(keywords.at(j).at(0)) {
                                temp = text(weight: "bold", fill: keywords.at(j).at(1))[#temp]
                                break
                            }
                            j = j + 1
                        }
                        // append the text on a new line, left-justified
                        content = content + align(left)[#v(-10pt)#temp]
                    }
                    i = i + 1
                }

                table.cell(fill: fill-color)[#content]
            }
        })
    )
}

#let get-numeric-month(input) = {
    let index = 0
    let numeric-month = -1
    while index < month-inputs.len() {
        for keyword in month-inputs.at(index) {
            if keyword == lower(input) {
                numeric-month = index + 1
            }
        }
        index = index + 1
    }

    assert(
        numeric-month != -1,
        message: "Expected valid month received " + str(input)
    )

    return numeric-month
}

#let create-color-date-shading-arrays(encoding) = {
    let dates = ()
    let colors = ()

    // checks for date/date array and color pair
    assert(
        type(encoding) == array,
        message: "Expected encoding in format: (date/date array, color)"
    )

    // checks that the first element is an array
    assert(
        type(encoding.at(0)) == array,
        message: "Position 0 must be a date or array of dates"
    )

    // check that the second element is a color
    assert(
        type(encoding.at(1)) == color,
        message: "Position 1 must be a color"
    )
    colors.push(encoding.at(1))

    // if the first element is an array of dates
    if type(encoding.at(0).at(0)) == array {
        // check if all the dates are in a valid format
        assert(
            encoding.at(0).all(s => {
            (type(s.at(0)) == str or type(s.at(0)) == int) and type(s.at(1)) == int
            }),
            message: "Expected all shading dates to be in the format: (int or str, int)"
        )
        let i = 0
        while i < encoding.at(0).len() {
            if type(encoding.at(0).at(i).at(0)) == str {
                encoding.at(0).at(i).at(0) = get-numeric-month(encoding.at(0).at(i).at(0))
            }
            i = i + 1
        }

        dates.push(encoding.at(0))
    // if the first element is a single date
    } else {
        assert(
            ((type(encoding.at(0).at(0)) == str or type(encoding.at(0).at(0)) == int) and type(encoding.at(0).at(1)) == int),
            message: "Expected date to be in the format: (int or str, int) received (" + str(type(encoding.at(0).at(0))) + ", " + str(type(encoding.at(0).at(1))) + ")"
        )
        if type(encoding.at(0).at(0)) == str {
            encoding.at(0).at(0) = get-numeric-month(encoding.at(0).at(0))
        }

        let all-dates = ()
        all-dates.push(encoding.at(0))
        dates.push(all-dates)
    }

    return (dates, colors)
}

/// draw-calendar: Render the calendar as specified
/// - month-range (int, int) OR (str, str): the start and ending months of the range desired for the calendar
/// - day-range (int, int): the starting and ending day values for the calendar
/// - title str: adds the provided title to the calendar, defaults to no title
/// - is-leap-year bool: indicates whether the year is a leap year (feb has 29 days), defaults to false
/// - is-mon-start bool: toggles between sunday and monday starts for the week, defaults to sunday start
/// - color-codes (str, color) OR ((str, color), (str, color), ...): indicates if certain words should be colored the specified color, defaults to empty array
/// - shading:
#let draw-calendar(month-range, day-range, title: "", is-leap-year: false, is-mon-start: false, color-codes: (), shading: (), due-dates: ()) = {
    //////////////////
    // MONTH CHECKS //
    //////////////////
    assert(
        type(month-range) == array,
        message: "Expected month-range to be array but received " + str(type(month-range))
    )

    assert(
        month-range.len() == 2,
        message: "Expected month-range to be an array of length 2 but received array of length " + str(month-range.len())
    )

    assert(
        type(month-range.at(0)) == int or type(month-range.at(0)) == str,
        message: "Expected month-range to be array of int or string but received " + str(type(month-range.at(0)))
    )

    assert(
        type(month-range.at(1)) == int or type(month-range.at(1)) == str,
        message: "Expected month-range to be array of int or string but received " + str(type(month-range.at(1)))
    )

    // if a str month is provided, check that it is valid and convert to numeric
    let month-val = 0
    while month-val < month-range.len() {
        if type(month-range.at(month-val)) == str {
            month-range.at(month-val) = get-numeric-month(month-range.at(month-val))
        }
        month-val = month-val + 1
    }

    assert(
        month-range.at(1) > 0 and month-range.at(1) < 13,
        message: "Second month-range value must be >0 and <13"
    )

    assert(
        month-range.at(0) > 0 and month-range.at(0) < month-range.at(1),
        message: "First month-range value must be >0 and <" + str(month-range.at(1))
    )


    ////////////////
    // DAY CHECKS //
    ////////////////
    assert(
        type(day-range) == array,
        message: "Expected day-range to be array but received " + str(type(day-range))
    )

    assert(
        month-range.len() == 2,
        message: "Expected day-range to be an array of length 2 but received array of length " + str(month-range.len())
    )

    assert(
        type(day-range.at(0)) == int,
        message: "Expected day-range to be array of int but received " + str(type(day-range.at(0)))
    )

    assert(
        type(day-range.at(1)) == int,
        message: "Expected day-range to be array of int but received " + str(type(day-range.at(1)))
    )

    assert(
        day-range.at(0) > 0 and day-range.at(0) < 32 and day-range.at(1) > 0 and day-range.at(1) < 32,
        message: "Day-range values must be >0 and <32"
    )


    /////////////////
    // TITLE CHECK //
    /////////////////
    assert(
        type(title) == str,
        message: "Expected title to be string but received " + str(type(title))
    )

    // format title if provided
    if title != "" {
        text[= #title]
        line(length: 100%, stroke: 2pt)
        v(5pt)
    }


    /////////////////////
    // LEAP YEAR CHECK //
    /////////////////////
    assert(
        type(is-leap-year) == bool,
        message: "Expected is-leap-year to be bool but received " + str(type(is-leap-year))
    )


    ////////////////////////
    // MONDAY START CHECK //
    ////////////////////////
    assert(
        type(is-mon-start) == bool,
        message: "Expected is-mon-start to be bool but received " + str(type(is-mon-start))
    )


    /////////////////////////
    // COLOR CODING CHECKS //
    /////////////////////////
    assert(
        type(color-codes) == array,
        message: "Expected color-codes to be an array but received " + str(type(color-codes))
    )

    if color-codes != () {
        // allows user to pass a singular keyword and color pair: (str, color)
        // by converting to an array of pairs
        if type(color-codes.at(0)) == str and type(color-codes.at(1)) == color {
            let temp = color-codes
            color-codes = ()
            color-codes.push(temp)
        }

        // if single value is not in the correct format: (str, color)
        assert(
            type(color-codes.at(0)) == array,
            message: "Expected color-codes in the format: (\"keyword\", color)"
        )

        // if an array of pairs is provided: ((str, color), (str, color), ...)
        assert(
            color-codes.all(c => {
            type(c.at(0)) == str and type(c.at(1)) == color
            }),
            message: "Expected all color-code pairs to be in the format: (str, color)"
        )
    }


    ////////////////////
    // SHADING CHECKS //
    ////////////////////
    assert(
        type(shading) == array,
        message: "Expected shading to be an array but received " + str(type(shading))
    )

    let dates = ()
    let colors = ()
    if shading != () {
        // handles case of one (or more) dates and one color: ((int or str, int), color) OR ( ((int or str, int), (int or str, int), ...), color )
        if type(shading.at(1)) == color {
            let out = create-color-date-shading-arrays(shading)
            dates = out.at(0)
            colors = out.at(1)
        // handles case of multiple colors
        } else {
            for encoding in shading {
                let out = create-color-date-shading-arrays(encoding)
                dates.push(out.at(0).at(0))
                colors.push(out.at(1).at(0))
            }
        }
    }

    let month = month-range.at(0) - 1
    let start-day = day-range.at(0)
    let days = (none, 1)
    let end-day = none

    while month < month-range.at(1) {
        // if we are at the last month,
        // set the end-day to what the user requested
        if month == month-range.at(1) - 1 {
            end-day = day-range.at(1)
        }

        month-header(month, is-mon-start: is-mon-start)
        days = construct-day-arr(month, start-day, end-day, days.at(1), is-leap-year: is-leap-year, shading: dates, assigns: due-dates)
        construct-month-table(days.at(0), color-codes, colors)

        start-day = days.at(2)
        month = month + 1
    }
}


