


#let lab_init(body) = {
  set page(margin: 40pt)
  set text( 
    font: ("Verdana"), 
    size: 12pt, 
    fill: black, 
    weight: "regular"
  )
  set raw(theme: "../themes/InspiredGitHub.tmTheme")  
  show raw: set text(font: "Courier New", weight: "bold", size: 10pt)

  // defaults to 1.2, but on labs specifically, this is not enough spacing
  set par(spacing: 1.6em)
  
  body
}


#let wt(body, dsp: -10pt) = {
  set text(fill: white, size: 0.01pt)
  show raw: set text(fill: white, size: 0.01pt)
  v(dsp)
  text(body)
}


#let cmd_color(input, dsp: 0pt) = {
  let userIn = false
  let error = false
  v(2pt)
  set text(font: "Courier New", weight: "bold", size: 10pt, fill: rgb("#d1d1d1"))
  highlight(fill: rgb("#383838"), top-edge: 15pt, bottom-edge: -10pt, radius: 3pt, extent: 6pt)[

    #if type(input) == array {

      let max_len = 0
      for line in input {
        if line.len() > max_len {
          max_len = line.len()
        }
      }

      v(5pt)
      for line in input {

        let num_spaces = max_len - line.len()

        if line != " " {

          if line.split().at(0) == ">" {
            userIn = true
            error = false
          } else  if line.split().at(0) == "Exception" {
            userIn = false
            error = true
          } else {
            userIn = false
            error = false
          }

          h(7pt + dsp)
          for word in line.split() {
            if error {
              text(fill: rgb("#a83232"), word + " ")
            }
            else if (userIn or word == "Example.java" or word == "Example" or word == "ZipCrackerSingleThread") and word != ">" {
              text(fill: rgb("#58ad37"), word + " ")
            }
            else if word == "java" or word == "javac"{
              text(fill: rgb("#ad7a37"), word + " ")
            } else {
              text(word + " ")
            }
          }
        } else {
          h(7pt + dsp)
          text(" ")
          text(" ")
        }

        for i in range(num_spaces) {
          text(" ")
        }
        v(-1pt)
      }
    } else {
        if input.split().at(0) == ">" {
          userIn = true
          error = false
        } else  if input.split().at(0) == "Exception" {
          userIn = false
          error = true
        } else {
          userIn = false
          error = false
        }

        h(12pt + dsp)
        for word in input.split() {
          if error {
            text(fill: rgb("#a83232"), word + " ")
          }
          else if (userIn or word == "Example.java" or word == "Example" or word == "ZipCrackerSingleThread") and word != ">" {
            text(fill: rgb("#58ad37"), word + " ")
          }
          else if word == "java" or word == "javac"{
            text(fill: rgb("#ad7a37"), word + " ")
          } else {
            text(word + " ")
          }
        }
        v(3pt)
    }
 ]
 v(10pt)
}


#let uml(title, fields, methods) = {
  table(
  table.hline(),
  table.vline(),
  stroke: none,
  inset: 5pt,
  align: center,
  fill: rgb("#ffe1c4"),
  table.header(
    title,
  ),
  table.vline(),
  table.hline(start: 0),

  v(-5pt),
  for field in fields {
      v(-5pt)
      table.cell(align: left, field)
  },

  table.hline(start: 0),

  v(-5pt),
  for method in methods {
      v(-5pt)
      table.cell(align: left, method)
  },

  table.hline()
)
}


#let lp(class, lpNum, title) = {
  text[= CS-118#class Lab Problem #lpNum: #title]
  line(length: 100%, stroke: 0.5pt)
}

#let purpose(body) = [
  *PURPOSE: *
  #body
]

#let directions(body) = [
  #v(15pt)
  *DIRECTIONS: *
  #body
]

#let partA(body) = [
  #v(15pt)
  *DIRECTIONS: *
  #v(-5pt)
  === Part A (Due by end of first lab session)
  #v(0pt)
  #body
]

#let partB(body) = [
  #v(15pt)
  === Part B
  #v(0pt)
  #body
]

#let extra(title: "Extra", body) = [
  #v(15pt)
  *#title: *
  #body
]

#let example(io, text) = [
  #v(15pt)
  *EXAMPLE: *
  #text
  #cmd_color(io)
]

#let lab_rubric(docOverride: "Documentation", partAOverride: "Part A correct", partBOverride: "Part B correct", notes) = [
  #v(15pt)
  == RUBRIC:
  #v(5pt)

  #notes
  #v(0pt)

  *[1pt\]*
  #h(10pt)
  *#docOverride*
  #v(-5pt)
  *\[1pt\]*
  #h(10pt)
  *#partAOverride*
  #v(-5pt)
  *\[1pt\]*
  #h(10pt)
  *#partBOverride*

]


#let rubric(baseRubric, styleRubric, bonusRubric: none, wtRubric: none, ..notes) = {

  let baseTotal = baseRubric.at(0).sum()

  text[== RUBRIC:]
  v(5pt)
  text[(#baseTotal pts) *Base Functionality*]
  v(-5pt)
  for i in range(baseRubric.at(0).len()) {
    h(36pt)
    if baseRubric.at(0).at(i) != 0 {
      text[\[#baseRubric.at(0).at(i)\] #baseRubric.at(1).at(i)]
    } else {
      text[#baseRubric.at(1).at(i)]
    }
    v(-5pt)
  }

  let styleTotal = styleRubric.at(0).sum()

  v(10pt)
  text[(#styleTotal pts) *Style*]
  v(-5pt)
  for i in range(styleRubric.at(0).len()) {
    h(36pt)
    if styleRubric.at(0).at(i) != 0 {
      text[\[#styleRubric.at(0).at(i)\] #styleRubric.at(1).at(i)]
    } else {
      text[#styleRubric.at(1).at(i)]
    }
    v(-5pt)
  }

  if bonusRubric != none{
    let extraTotal = bonusRubric.at(0).sum()
    let extraPercent = extraTotal / 10

    v(10pt)
    text[(#extraTotal pts) *Extra Credit* (#extraTotal points == #extraPercent% additional credit in the course)]
    v(-5pt)
    for i in range(bonusRubric.at(0).len()) {
      h(36pt)
      if bonusRubric.at(0).at(i) != 0 {
        text[\[#bonusRubric.at(0).at(i)\] #bonusRubric.at(1).at(i)]
      } else {
        text[#bonusRubric.at(1).at(i)]
      }
      v(-5pt)
    }
  }

  if wtRubric != none{
    let wtTotal = wtRubric.at(0).sum()

    let wtPercent = wtTotal / 10
    wt[
      #text[(#wtTotal pts) *Extra Credit* (#wtTotal points == #wtPercent% additional credit in the course)]
      #v(0pt)
      #for i in range(wtRubric.at(0).len()) {
        h(36pt)
        text[\[#wtRubric.at(0).at(i)\] #wtRubric.at(1).at(i)]
        v(-5pt)
      }
    ]
  }

  v(15pt)
  text(weight: "semibold")[
  IMPORTANT NOTES:
  #v(-5pt)
  #line(length: 20%, stroke: 0.5pt)
  #if notes != none {
    v(0pt)
    set text(fill:  rgb("#b52424"))
    for x in notes.pos() {
      [- #x]
    }
    set text(fill: black)
  }
  #v(0pt)
  - Submissions that do not compile will receive a zero
  - Submissions with improperly cited AI  will receive a zero and an academic integrity violation
  - Submissions that are partially or fully copied from another submission will receive a zero and an academic integrity violation]
}
