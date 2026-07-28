// months with their corresponding default number of days
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

// acceptable string inputs for each month
// case-insensitive
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

// array for days of the week
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


/// days-of-week: prints the days of the week to the document
/// is-mon-start bool: flag to control whether to start on sunday or monday
#let days-of-week(is-mon-start: false) = {
    let days = day-arr
    // if monday start,
    // removes sunday from the beginning and appends it to the end
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


/// month-header: prints the month header and days of the week to the document
/// - month-id int: id for the month to print
/// - is-mon-start bool: flag to control whether to start on sunday or monday
#let month-header(month-id, is-mon-start: false) = {
    v(-10pt)
    // print month
    text[== #month-days.at(month-id).at(0)]
    line(length: 100%, stroke: 1pt)
    v(-15pt)
    // print days of week
    days-of-week(is-mon-start: is-mon-start)
    v(-15pt)
    line(length: 100%, stroke: 1pt)
}


/// construct-day-arr: constructs an array with all the encodings for each day in a month as well as info to assist the creation of encodings for the next month
/// - month-id int: the month to construct days for
/// - start int: the day to start the month on
/// - last-month-max int: allows the month to end sooner than the number of days in the month
/// - last-week-num int: the most recently printed week number
/// - is-leap-year bool: flag to control number of days in february
/// - shading array: any shading info to encode
/// - assigns array: any text to encode on the day
#let construct-day-arr(month-id, start, last-month-max, last-week-num, is-leap-year: false, shading:(), assigns:(), overviews:()) = {
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

        // add day number to day text
        let day-text = str(day)

        // iterate through any shadings provided
        let i = 0
        while i < shading.len() {
            let j = 0
            // grab the dates from the shading arrays
            let dates = shading.at(i)
            // iterate through all provided dates
            while j < dates.len() {
                // grab individual date
                let date = dates.at(j)
                // check if the date matches the current date
                if (date.at(0) == (month-id + 1)) and (date.at(1) == day) {
                    // if it is a match, encode the shading id #
                    day-text = day-text + "𖦹" + str(i)
                    break
                }
                j = j + 1
            }
            i = i + 1
        }

        // iterate through any assigns provided
        i = 0
        while i < assigns.len() {
            // grab an assignment
            let item = assigns.at(i)
            // check if the date matches the current date
            if (item.at(0) == (month-id + 1)) and (item.at(1) == day) {
                // if it is a match, encode the assignment text
                day-text = day-text + "𖦹" + item.at(2)
            }
            i = i + 1
        }

        // if there is overview text, and we are on the middle day of the week,
        if overviews != () and calc.rem(day-nums.len(), 8) == 4 {
            // iterate through all overviews
            let overview-index = 0
            while overview-index < overviews.len() {
                // if overview week num matches current week num, add overview text
                if (week-count - 1) == overviews.at(overview-index).at(0) {
                    day-text = day-text + "𖦹OVR𖦹" + overviews.at(overview-index).at(1)
                }
                overview-index = overview-index + 1
            }
        }

        // inserts the day number and associated encodings
        day-nums.push(day-text)

        day = day + 1
        // resets day if the max is reached
        if day > max-days {
            day = 1
            reach-max = true
            // increment current month
            month-id = month-id + 1
        }
    }
    return (day-nums, week-count, day)
}


/// construct-month-table: creates and draws the table of days for a specific month
/// - days ([DAY NUM ENCODING SEPARATED BY DASHES], [DAY NUM ENCODING SEPARATED BY DASHES], ...): contains all the day numbers and appropriate encodings for each day
/// - keywords ((str, color), (str, color), ...): array of keywords and their corresponding colors
/// - shading-colors (color, color, ...): array of colors to shade specified cells
/// - overview-color color: color for overview text
#let construct-month-table(days, keywords, shading-colors, overview-color) = {
    v(-18pt)

    show table.cell: it => {
        // matchs to the text "week #" followed by a one or two digit number
        // rotates and bolds the text

        // MAGIC LINE: DO NOT TOUCH
        // if you want to change offset left to right, ONLY TOUCH................................................................THIS NUMBER
        //                                                                                                                           vvv
        show regex("week #\d{1,2}"): it => text(size:11pt, weight: "bold")[#align(horizon)[#box(width: 1000pt)[#rotate(-90deg)[#it#v(15pt)]]]]
        // END MAGIC LINE
        it
    }
    table(
        columns: (0fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
        align: center,
        rows: 70pt,
        ..days.map(text-str => {
            // split day date on dash
            let all-pieces = text-str.split("𖦹")
            // if there is only a number
            if all-pieces.len() == 1 {
                // print that number bolded centered in the cell
                table.cell()[#text(weight: "bold")[#text-str]]
            } else {
                // initialize content to include the number
                let num = all-pieces.at(0)
                let content = text(weight: "bold")[#num]

                // init vars
                let fill-color = none
                let temp = []
                let skip = false
                let amt-down = 0pt

                // start grabbing encodings at 1 since we already grabbed the day num
                let i = 1

                // iterate through day encodings
                while i < all-pieces.len() {
                    skip = false

                    // grab current encoding piece
                    temp = all-pieces.at(i)

                    // checks for overview flag and adds the overview text
                    if temp == "OVR" {
                        i = i + 1
                        let disp = 30pt - amt-down
                        content = content + v(disp) + box(width: 1000pt)[#align(center)[#text(fill: overview-color, size: 12pt)[*_#all-pieces.at(i)_*]]]
                        skip = true
                    }

                    if skip == false {
                        // checks if the cell should be shaded
                        let shade-id = 0
                        while shade-id < shading-colors.len() {
                            // if encoding is the id matching a shading id
                            if temp == str(shade-id) {
                                // update the fill color
                                fill-color = shading-colors.at(shade-id)
                                // no need to check for keywords w/ this encoding
                                skip = true
                            }
                            shade-id = shade-id + 1
                        }
                    }

                    // only need to check for keywords if we determine it is not a shading key
                    if skip == false {
                        // check all keywords and perform color coding as needed
                        let j = 0
                        while j < keywords.len() {
                            // if the encoding matches a keyword
                            if temp.contains(keywords.at(j).at(0)) {
                                // format the text appropriately and exit
                                temp = text(weight: "bold", fill: keywords.at(j).at(1))[#temp]
                                break
                            }
                            j = j + 1
                        }
                        // append the text on a new line, left-justified
                        content = content + align(left)[#v(-13pt)#temp]
                        // adjusts the displacement for overview text based on how many lines of text have been added
                        amt-down = amt-down + 12.25pt
                    }
                    i = i + 1
                }
                // print content to the cell
                table.cell(fill: fill-color)[#content]
            }
        })
    )
}


/// get-numeric-month: takes a string and sees if it is a valid month; if it is, converts it to a numeric month
/// - input str: string to check if it is a valid month
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


/// create-color-date-shading-arrays: Handles all possible types of shading encodings
/// - encoding: the encoding to check if it is in the right format for shading param
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
/// - month-range (int or str, int or str): the start and ending months of the range desired for the calendar
/// - day-range (int, int): the starting and ending day values for the calendar
/// - title str: adds the provided title to the calendar, defaults to no title
/// - is-leap-year bool: indicates whether the year is a leap year (feb has 29 days), defaults to false
/// - is-mon-start bool: toggles between sunday and monday starts for the week, defaults to sunday start
/// - color-codes (str, color) OR ((str, color), (str, color), ...): indicates if certain words should be colored the specified color, defaults to an empty array
/// - shading ([DATE], color) OR ([DATE ARRAY], color) OR (([DATE], color), ([DATE ARRAY], color), ...) where [DATE] = (int or str, int): takes pairs of date(s) and colors to shade the date boxes accordingly, defaults to an empty array
/// - due-dates (int or str, int, str) OR ((int or str, int, str), (int or str, int, str), ...): indicates text that the user wants printed on a specific date, defaults to an empty array
/// - week-overviews (int, str, color) OR (((int, str), (int, str), ...), color): indicates a week number and text to add as an overview to that week
#let draw-calendar(month-range, day-range, title: "", is-leap-year: false, is-mon-start: false, color-codes: (), shading: (), due-dates: (), week-overviews: ()) = {
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

    // constructs proper dates and colors arrays
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


    /////////////////////
    // DUE DATE CHECKS //
    /////////////////////
    assert(
        type(due-dates) == array,
        message: "Expected due-dates to be an array but received " + str(type(due-dates))
    )

    // constructs proper date text arrays
    let date-text = ()
    if due-dates != () {
        // handles a single date text
        if (type(due-dates.at(0)) == int or type(due-dates.at(0)) == str) and type(due-dates.at(1)) == int and type(due-dates.at(2)) == str {
            if type(due-dates.at(0)) == str {
                due-dates.at(0) = get-numeric-month(due-dates.at(0))
            }
            date-text.push(due-dates)
        // handles multiple dates
        } else {
            assert(
                due-dates.all(d => {
                    type(d) == array and d.len() == 3 and (type(d.at(0)) == int or type(d.at(0)) == str) and type(d.at(1)) == int and type(d.at(2)) == str
                    }),
                    message: "Expected due-dates to be an array of arrays of form (int or str, int, str)"
            )

            let due-date-index = 0
            while due-date-index < due-dates.len() {
                if type(due-dates.at(due-date-index).at(0)) == str {
                    due-dates.at(due-date-index).at(0) = get-numeric-month(due-dates.at(due-date-index).at(0))
                }
                date-text.push(due-dates.at(due-date-index))
                due-date-index = due-date-index + 1
            }
        }
    }


    //////////////////////
    // OVERVIEWS CHECKS //
    //////////////////////
    assert(
        type(week-overviews) == array,
        message: "Expected week-overviews to be an array but received " + str(type(week-overviews))
    )

    let overview-text = ()
    let overview-color = black
    if week-overviews != () {
        // account for single week # and text pair
        if type(week-overviews.at(0)) == int and type(week-overviews.at(1)) == str {
            // accounts for optional color added
            if week-overviews.len() > 2 {
                assert(
                    type(week-overviews.at(2)) == color,
                    message: "Expected week-overviews to be an array of form (int, str, color) but received (" + str(type(week-overviews.at(0))) + ", " + str(type(week-overviews.at(1))) + ", " + str(type(week-overviews.at(2))) + ")"
                )
                overview-color = week-overviews.at(2)
            }
            assert(
                week-overviews.at(0) > 0,
                message: "Week-overviews week number must be greater than 0; received " + str(week-overviews.at(0))
            )
            overview-text.push((week-overviews.at(0), week-overviews.at(1)))
        // account for array of week # and text pairs
        } else {
            assert(
                type(week-overviews.at(0)) == array,
                message: "Expected week-overviews to be an array of arrays but received " + str(type(week-overviews.at(0)))
            )

            let all-overviews = ()
            // account for color provided
            if week-overviews.len() > 1 and type(week-overviews.at(1)) == color {
                overview-color = week-overviews.at(1)

                assert(
                    week-overviews.at(0).all(w => {
                        type(w.at(0)) == int and w.at(0) > 0 and type(w.at(1)) == str
                        }),
                        message: "Expected week-overviews to be an array of arrays of form (((int > 0, str), (int > 0, str), ...), color)"
                )
                all-overviews = week-overviews.at(0)
            // account for no color provided
            } else {
                assert(
                    week-overviews.all(w => {
                        type(w.at(0)) == int and w.at(0) > 0 and type(w.at(1)) == str
                        }),
                        message: "Expected week-overviews to be an array of arrays of form ((int > 0, str), (int > 0, str), ...)"
                )
                all-overviews = week-overviews
            }

            // add all pairs
            let overview-index = 0
            while overview-index < all-overviews.len() {
                overview-text.push((all-overviews.at(overview-index).at(0), all-overviews.at(overview-index).at(1)))
                overview-index = overview-index + 1
            }
        }
    }


    //////////////////////////////////
    // ACTUAL CALENDAR CONSTRUCTION //
    //////////////////////////////////

    // adjust start month for zero-indexing
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

        // create header for the month
        month-header(month, is-mon-start: is-mon-start)
        // construct an array of the days and all their appropriate encodings for that month
        days = construct-day-arr(month, start-day, end-day, days.at(1), is-leap-year: is-leap-year, shading: dates, assigns: date-text, overviews: overview-text)
        // print table of days w/ appropriate info
        construct-month-table(days.at(0), color-codes, colors, overview-color)

        // get new start day from prior day array generation
        start-day = days.at(2)

        month = month + 1
    }
}


