
![Codepoint logo](./img/logo.png)
# Codepoint
A library for creating programming assignments and exams with automatic point tracking, terminal blocks, code line-numbering, and pre-formatted question types.

## Labs
The labs module configures layout, custom raw-code themes, and uniform section layouts for lab assignment handouts.

- Terminal I/O Blocks (`#labs.example` / `#labs.command-block`): Renders command-line simulation blocks with automatic color coding for common language keywords (`java`, `python`, `gcc`, `cargo`, etc.), terminal prompts (`>`), and errors.

- UML Class Layouts (`#labs.uml`): Built-in tables for rendering UML class specifications

- Rubrics (`#labs.lab-rubric` / `#labs.rubric`): Renders point-breakdown blocks alongside automated, and supplemental notes

```typst
#show: labs.init

#labs.header("CS-2000", "Introduction to OOP", number: 1)

#labs.purpose([Learn how to instantiate classes and compile Java code.])

#labs.directions([
  Create a `Car` class according to the specifications below. Ensure you use the proper visibility modifiers.
])

#labs.uml(
  "Car",
  ("- make: String", "- year: int"),
  ("+ Car(make: String, year: int)", "+ getMake(): String")
)

#labs.example(
  ("> javac Main.java", "> java Main", "Car created successfully!"),
  [Compile and run your program in the terminal to verify output:]
)

#labs.lab-rubric(
  base-rubric: (
    ([Compiles without errors], 1),
    ([Produces correct terminal output], 1),
  ),
  style-rubric: (
    ([Code matches provided UML design], 1),
  )
)
```