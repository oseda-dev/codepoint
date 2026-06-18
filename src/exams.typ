#let title-state = state("title", "")

#let total_points = counter("points")


/// exam_init: Initialize an exam with a show rule 
/// eg: #show: exam.exam_init
#let exam_init(body) = {
  set page(margin: 40pt)
  set text( 
    font: ("Aptos"),
    size: 12pt, 
    fill: black, 
    weight: "regular"
  )
  set raw(theme: "../themes/codepoint.tmTheme")  
  show raw: set text(font: "Courier New", weight: "bold", size: 10pt)

  set par(spacing: 1.2em)
  
  body
}


#set page(header: [
  #context title-state.get()
])

#let setup(title) = {
  title-state.update(title)
}

/// header: Render a header for the exam, will check total number of points 
/// Usually done via something like:
/// #exam.setup("CS-1181 Quiz #1")
/// #set page(header: [
///   #context e.title-state.get()
/// ])
/// #e.header()
/// @param out_of int Maximum points the exam is taken out of
#let header(out_of: none) = [
  #context {
    let max_earnable = total_points.final().at(0)
    
    // typst supports conditional assignments :)
    let max_scorable = if (out_of != none) { 
      out_of 
    } else { 
      max_earnable
    }

    grid(
      columns: (1fr, 1fr),
      align(left)[
        #text(size: 17pt)[
          Name: #box(width: 1fr, move(dy: 2pt, line(length: 100%, stroke: 1pt)))
        ]
      ],
      align(right)[
        #text(size: 17pt)[
          #grid(
            rows: (0pt, 20pt),
            align(right)[
              // need a box wrap 
              #box(width: 40pt, move(dy: 2pt, line( 
                length: 130%, stroke: 0.7pt
              )))
              #("/ " + str(max_scorable))
            ],
            if out_of != none {
              v(1.2em)
              "Max: " + str(max_earnable) + " pts"
            }
          )
        ]
      ]
    )
  }
]

#let spacer() = {
  v(10pt)
}


#let cur-question = state(
  "num_qs", 1
)


/// question: Create a generic question
/// @param body content Question Body
/// @param points int Number of points the question is worth
#let question(body, points: 1) = context {
  cur-question.update(n => n + 1)
  total_points.update(p => p + points)
  let qnum = cur-question.get()
  
  block(width: 100%, breakable: true, inset: (bottom: 0.5em))[
    #grid(
      columns: (20pt, 1fr),
      column-gutter: 8pt,
      text(weight: "bold")[#qnum.],
      [#body #h(5pt) (#points pts)]
    )
  ]
}

#let c = counter("letter")

#let answer_indents = (1fr, 10fr, 1fr)


/// _num_to_fr_units: Map a number into a tuple of 1fr units
/// primarily used to make optional column passing to #multiple_choice easier
/// input = 3 -> output = (1fr, 1fr, 1fr)
/// input = 5 -> output = (1fr, 1fr, 1fr, 1fr, 1fr)
/// @param num int number to map
/// @return array Array of num fr units
#let _num_to_fr_units(num) = {
  range(num).map(i => 1fr)
}



/// multiple_choice: Create a multiple choice question
/// @param body content Body of question
/// @param points int = 1 Points the question is worth
/// @param cols [int | array ] = 1 Number of columns to render the answer. Pass an array of units for specific spacing e.g. (1fr, 1fr, 12pt)
#let multiple_choice(body, points: 1, cols: 1, ..answers) = {
  let cols_type = type(cols)

  block[
    #c.update(0)
    #question(body, points: points)
    #v(-0.4em)
    #grid(
      columns: answer_indents,
      rows: (auto),
      "",
      block[
        #grid(
          columns: {
            if(cols_type) == int {
              _num_to_fr_units(cols)
            } else {
              cols
            }
          },
          rows: auto,
          column-gutter: 5pt,
          row-gutter: 15pt,
          ..answers.pos().map(answer => {
            c.step()
            block[
              #context c.display("a"). #" " #answer
            ]
          })
        )
      ],
      "",
    )
  ]
}


/// https://xkcd.com/221/
/// Not cryptographically secure
#let _shuffle(arr, seed: 4) = {
  for i in range(arr.len()) {
    let rnd_index = calc.rem(i * seed, arr.len())
    
    // swap via destructuing
    (arr.at(i), arr.at(rnd_index)) = ((arr.at(rnd_index), arr.at(i)))
  }

  arr
}



#let _matching(q_body, points, seed: 4, pairs) = {
  // condense each pair down into just each side => then shuffle
  let left_opts = _shuffle(
    pairs.map(pair => pair.at(0)),
    seed: seed
  )

  let right_opts = _shuffle(
    pairs.map(pair => pair.at(1)),
    seed: seed + 1,
  )
  

  block[
    #c.update(0)
    #question(q_body, points: points)
    #spacer()
    #grid(
      columns: (1fr, 4fr, 7fr),
      "",
      align(left)[
        #for left_item in left_opts {
          block[
            #box(width: 40pt, move(dy: 2pt, line(length: 85%, stroke: 0.5pt))) #left_item
            #spacer()
          ]
        }
      ],
      align(left)[
        #for right_item in right_opts {
          block[
            #c.step()
            #context c.display("a"). #right_item
            #spacer()
          ]
        }
      ]
    )
  ]
}

#let _validate_pairs(pairs) = {
  assert(type(pairs) == array, message: "Expected pairs to be an array, got " + str(type(pairs)))
  
  for pair in pairs {
    assert(type(pair) == array and pair.len() == 2, message: "Every elem. in pairs must be an array of exactly 2 elements: (left, right)")
  }
}

/// matching: Create a matching question
/// e.g
/// Cat      A. Canine
/// Dog      B. Feline
/// Fish     C. Aquatic Creature
/// @param q_body content body of question to ask
/// @param points int = none points the question is worth. Once wrapped, this will default to the length of pairs
/// @param seed int = 4 Random seed used for shuffling each side
/// @param pairs array An array containing pairs of answers/definitions 
#let matching(q_body, points: none, seed: 4, pairs) = {
  // points will end up defaulting to len of pairs if not passed
  assert(points == none or type(points) == int, message: "Expected points to be integer or none, received: " + str(type(points)))
  assert(type(seed) == int, message: "Expected seed to be integer, received: " + str(type(seed)))
  
  _validate_pairs(pairs)

  let real_points = -1

  if(points == none){
    real_points = pairs.len()
  } else {
    real_points = points
  }

  _matching(q_body, real_points, seed: seed, pairs)
}
}


#let tf_block(q_body, ..statements, points: 1) = {
  let num = counter("I")
  num.step() 
  block[
    #question(q_body, points: points)
    #v(-0.4em)
    #for statement in statements.pos() {
      block[
        #grid(
          columns: (42pt, 18pt, 9fr, 1fr),
          rows: (auto),
          "",
          block[
            #set text(font: "Libertinus Serif")
            #context num.display("I").
            #context num.step()
          ],
          statement,
          box(width: 1fr, move(dy: 2pt, line(length: 70%, stroke: 0.5pt)))
        )
      ]
    }
  ]
}

/// short_answer: Create a short answer question
/// @param q_body content Question Body
/// @param lines int = 1 lines of space to give the user, renders as actual lines
/// @param points int = 1 points the question is worth
#let short_answer(q_body, lines: 1, points: 1) = {
  question(q_body, points: points)
  
  // you don't need the full spacing from the question before the first line
  v(-10pt)
  block(width: 100%, inset: (left: 20pt))[
    #for _ in range(lines) {
      // line spacing
      v(25pt) 
      line(length: 90%, stroke: 0.5pt)
    }
  ]
}


/// free_response: Create a free response question2
/// @param q_body content Question Body
/// @param lines int = 1 lines of space to give the user, renders as empty space
/// @param points int = 1 points the question is worth
#let free_response(q_body, lines: 1, points: 1) = {
  question(q_body, points: points)

  // i did not know you could just multiply units like that
  v(15pt * lines)
}

/// code_block: Create a code block formatted for exams
/// Wraps in box to the edge of the code, can add white space if need it to be longer
/// @param raw_code content(raw) raw code block, eg. ``````java public class...``````
/// @param include-line-numbers boolean Boolean param for whether line numbers should be included in the output
#let code_block(include-line-numbers: true, raw_code) = {

  let lines = raw_code.text.split("\n")  
  
  // fold to flat array of cells, 
  // (1, firstLine, 2, secondLine, etc
  // then spread to table values later 
  let table_values = ()
  // pythonic enumerate :)
  for (i, line) in lines.enumerate() {
    // push line number
    // table_values.push(text(fill: gray)[#(i + 1)]) // start at 1 instead of 0
    if include-line-numbers {
      table_values.push(raw([#(i + 1)].text))
      
    }

    // converting to raw like this loses the language context, so copy it to each line
    table_values.push(raw(line, lang: raw_code.lang)) 
  }

  // wrap in a box to avoid having conditional stroke

  let desired_columns = (auto)
  if include-line-numbers {
    desired_columns = (auto, auto)
  } 

  block(
    stroke: rgb("#d9d9d9"),
    inset: 2pt, // need some extra internal padding
    table(
      columns: desired_columns,
      stroke: none,
      inset: (x: 5pt, y: 3pt),
      ..table_values
    )
  )
}



