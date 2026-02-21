
// exam stuff

#let title-state = state("title", "")

#let total_points = counter("points")


#let exam_init(body) = {
  set page(margin: 40pt)
  set text( 
    font: ("Verdana"), 
    size: 12pt, 
    fill: black, 
    weight: "regular"
  )
  set raw(theme: "../themes/InspiredGitHub.tmTheme")  
  show raw: set text(font: "Courier New", weight: "bold", size: 10pt)

  set par(spacing: 1.2em)
  
  body
}

#let header() = [
  #grid(
    columns: (1fr, 1fr),
    align(center)[
      #text(size: 17pt)[
        #align(left)[
          #"Name:_____________________________"
        ]
      ]
    ],
    align(center)[
      #text(size: 17pt)[
        #align(right)[
          #grid(
            rows: (0pt, 20pt),
            align(center)[
              //#context title-state.get()
            ],
            align(right)[
              #"____ /" #context total_points.final().at(0) pts
            ]
          )
        ]
      ]
    ]
  )
]

#set page(header: [
  #context title-state.get()
])

#let setup(title) = {
  title-state.update(title)
}

#let spacer() = {
  v(10pt)
}





#let cur-question = state(
  "num_qs", 1
)

// #let question(body, num_points) = context {
//   cur-question.update(n => n + 1)
//   points.update(points => points + num_points)
//   let qnum = cur-question.get()
  
//   block(width: 100%, breakable: true)[
//     #grid(
//       columns: (20pt, 1fr),
//       column-gutter: 8pt,
//       text(weight: "bold")[#qnum.],
//       [#body #h(5pt) (#num_points pts)]
//     )
//   ]
// }

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


// maps a number into a tuple of 1fr units
// primarily used to make optional column passing to #multiple_choice easier
// input = 3 -> output = (1fr, 1fr, 1fr)
// input = 5 -> output = (1fr, 1fr, 1fr, 1fr, 1fr)
// etc.
#let _num_to_fr_units(num) = {
  range(num).map(i => 1fr)
}


#let multiple_choice(body, points: 1, cols: 1, ..answers) = {
  let cols_type = type(cols)

  block[
    #c.update(0)
    #question(body, points: points)
    #v(5pt)
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


#let matching(q_body, left_opts, right_opts, points: 1) = {
  // left and right are shadows
  block[
    #c.update(0)
    #question(q_body, points: points)
    #spacer()
    #grid(
    // should sum to 12, to match answer_indents
    // 1st is just a spacer
      columns: (1fr, 4fr, 7fr),
      "",
      align(left)[
        #for word in left_opts {
          block[
            #"____" #word
            #spacer()
          ]
        }
      ],
      align(left)[
        #for x in right_opts {
          block[
            #c.step()
            #context c.display("a"). #" " #x
            #spacer()
          ]
        }
      ]
    )
  ]
}

// need better name
#let multi_true_false(q_body, ..statements, points: 1) = {
  let num = counter("I")
  // Note: If you want to skip the first value (N), 
  // ensure your counter logic matches your document setup.
  num.step() 
  block[
    #question(q_body, points: points)
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
          "______"
        )
      ]
    }
  ]
}

#let free_response(q_body, num_lines, points: 1) = {
  question(q_body, points: points)
  for _ in range(num_lines) {
    v(15pt)
  }
}

#let short_answer(q_body, num_lines, points: 1) = {
  question(q_body, points: points)
  grid(
    rows: auto,
    "",
    columns: (1fr, 10fr, 1fr),
    ..for _ in range(num_lines) {
      (
        v(15pt),
        "___________________________________________________________________________"
      )
    },
    ""
  )
}

// will simply extend the box to the edge of the code, can add white space if need it to be longer
#let code_block(raw_code) = {
  box(stroke: (paint: rgb("#d9d9d9"), thickness: 2pt, cap: "round"), inset: (8pt))[
      #raw_code
  ]
}
