#let init(body) = [
  #set page(margin: 40pt)
  #set text(font: "Aptos Display", size: 12pt, fill: black, weight: "regular")

  #show raw: set text(font: "Courier New", weight: "bold", size: 10pt)
  // #set raw(theme: "Themes/InspiredGitHub.tmTheme")
  #body
]
