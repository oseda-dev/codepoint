


#let init(body) = {
  set page(margin: 40pt)
  set text( 
    font: ("Verdana"), 
    size: 12pt, 
    fill: black, 
    weight: "regular"
  )
  set raw(theme: "../themes/codepoint.tmTheme")  
  show raw: set text(font: "Courier New", weight: "bold", size: 10pt)

  // defaults to 1.2, but on labs specifically, this is not enough spacing
  set par(spacing: 1.6em)
  
  body
}


#let white-text(body, dsp: -10pt) = {
  set text(fill: white, size: 0.01pt)
  show raw: set text(fill: white, size: 0.01pt)
  v(dsp)
  text(body)
}



/// CMD-KEYWORDS: Set of common command keywords, used for syntax highlighting in cmd_color
#let _CMD-KEYWORDS = (
  // java lab specifics
  "java", 
  "javac", 
  // python lab specifics
  "python", 
  "pip",
  // JS lab specifics
  "npm",
  "node",
  // c/pp lab specifics
  "gcc",
  "g++",
  "make",
  // pulled from my most common commands
  "ls",
  "cd",
  "git",
  "code",
  "sudo",
  "touch",
  "rm",
  "mdkir",
  // rust lab specifics
  "rustc",
  "cargo",

)



/// cmd-color: Render content as terminal I/O to the page.
/// Common commands will be highlighted a unique color.
/// @param input content Body of terminal text
/// @param dsp length = 0pt Horizontal indendation/displacement
/// @param custom-keywords array = ("Example.java","Example","ZipCrackerSingleThread") Array of unique values to highlight differently
#let cmd-color(input, dsp: 0pt, custom-keywords: ("Example.java", "Example", "ZipCrackerSingleThread")) = {
  let userIn = false
  let error = false
  v(2pt)
  set text(font: "Courier New", weight: "bold", size: 10pt, fill: rgb("#d1d1d1"))
  highlight(fill: rgb("#383838"), top-edge: 15pt, bottom-edge: -10pt, radius: 3pt, extent: 6pt)[

    #if type(input) == array {
      let max-len = 0
      for line in input {
        if line.len() > max-len {
          max-len = line.len()
        }
      }

      v(5pt)
      for line in input {

        let num-spaces = max-len - line.len()

        if line != " " {
          // pulled this out for maintainability
          let first-word = line.split().at(0, default: "")
          if first-word == ">" {
            userIn = true
            error = false
          } else if first-word == "Exception" {
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
            // pulled this from the custom keywords instead of hard coded 118X specific terms
            // I still left them as default params for compatibility
            else if (userIn or custom-keywords.contains(word)) and word != ">" {
              text(fill: rgb("#58ad37"), word + " ")
            }
            // also pulled these out into a special command bank
            else if _CMD-KEYWORDS.contains(word){
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

        for i in range(num-spaces) {
          text(" ")
        }
        v(-1pt)
      }
    } else {
        let first-word = input.split().at(0, default: "")
        if first-word == ">" {
          userIn = true
          error = false
        } else if first-word == "Exception" {
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
          else if (userIn or custom-keywords.contains(word)) and word != ">" {
            text(fill: rgb("#58ad37"), word + " ")
          }
          else if _CMD-KEYWORDS.contains(word){
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
  text[= #class Lab Problem #lpNum: #title]
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

#let part-a(body) = [
  #v(15pt)
  *DIRECTIONS: *
  #v(-5pt)
  === Part A (Due by end of first lab session)
  #v(0pt)
  #body
]

#let part-b(body) = [
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
  #cmd-color(io)
]

#let lab-rubric(docOverride: "Documentation", partAOverride: "Part A correct", partBOverride: "Part B correct", notes) = [
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
    white-text[
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
