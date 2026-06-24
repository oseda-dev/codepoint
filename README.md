
![Codepoint logo](./img/logo.png)
# Codepoint
A library for creating programming assignments and exams with automatic point tracking, terminal blocks, code line-numbering, and pre-formatted question types.

## Exams
The exams module manages constraints for student testing, providing native support for multiple question types and smart grading headers.

- Common exam question types
  - Multiple Choice
  - Matching
  - Short Answer
  - Free Response
  - T/F Blocks

- Score Aggregation: Dynamic calculation of total possible points across all questions (`#exam.question`, `#exam.multiple-choice`, etc.) and prints inside the score at front of test.

- Answer Shuffling (`#exam.matching`): Shuffle matching question choices, preventing answer-key ordering mistakes during exam creation phase

- Numbered Code Snippets (`#exam.code-block`): Formats code containers into distinct line-numbered (optional) code blocks
```typst

#show: exams.init

#set page(header: [
  #context exams.title-state.get()
])
#exams.header(out-of: 5)

#exams.question([What is the difference between a class and an object?], points: 2)

#exams.short-answer([What is the purpose of a constructor?], lines: 3, points: 2)

#exams.multiple-choice(
  [Which of the following is a primitive type in Java?],
  points: 1,
  cols: 2, // Spreads choices across 2 columns
  [String],
  [int],
  [ArrayList],
  [Scanner]
)

#exams.code-block(
  include-line-numbers: true,
  ```java
  public class Main {
      public static void main(String[] args) {
          System.out.println("Exam block");
      }
  }
```)

#exams.matching(
  [Match the OOP concept to its definition.],
  seed: 4, // shuffle both sides,
  points: 2,
  (
    ("Encapsulation", "Data hiding via private fields."),
    ("Inheritance", "Subclassing a parent type."),
  )
)
```



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