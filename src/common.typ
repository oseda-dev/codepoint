#let init(body) = {
  set page(margin: 40pt)
  set text( 
    font: ("Verdana"), 
    size: 12pt, 
    fill: black, 
    weight: "regular"
  )
  set raw(theme: "../themes/InspiredGitHub.tmTheme")  
  show raw: set text(font: "Courier New", weight: "bold", size: 10pt)

  //setting the space between paragraphs to better
  // match the old Aptos Font 
  set par(spacing: 1.4em)
  
  body
}