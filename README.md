# CodePoint

A Typst library for creating programming documents and exams

## WIP
- Not backwards compatible with previous development versions


## Backward Compatibility Breaking Changes
- Project is no longer called `project-tool` or `typst-utils`
    - This will break imports

- `num_lines` is now a named argument for short answer style question functions
- `points` is now a named argument for all question functions
- `labRubric` renamed to `lab_rubric`

- Switched font to `Verdana`
    - This should be installed on most systems by default
    - We cannot add proprietary fonts to the hosted package

- `Themes/` renamed to `themes` for compatibility
    - We are still hosting the `Inspired GitHub Color Scheme for Sublime Text 3` by Seth Lopez
    - It is MIT licensed, so this is legal

- `Fonts` directory removed
    - Unless we supply a small, open font, Typst Universe cannot host this

- `create-local-package.sh` has been rewritten
    - Mostly used for development testing purposes
    - No longer copies `Fonts` directory
    - Tells you local import package name

- #labs.lp MUST be called with the full class name now 
    - e.g. `lp(CS-1181, ...)` instead of just `lp(1, ...)` 

- `multi_true_false` is now `tf_block`

- New directory structure. Allows for separate imports of exam and project stuff
```bash
codepoint         
├── LICENSE
├── README.md
├── create-local-package.sh
├── examples
│   ├── exam_example.typ
│   ├── lab_example.typ
│   └── proj_example.typ
├── lib.typ
├── src
│   ├── exams.typ
│   └── labs.typ
├── themes
│   └── InspiredGitHub.tmTheme
└── typst.toml
```

## Docs:

## exam_init
Initialize an exam with a show rule eg


## header
Render a header for the exam, will check total number of points Usually done via something like


## question
Create a generic question
### Parameters: 
body: `content`  Question Body 
 
points: `int`  Number of points the question is worth 
 


## _num_to_fr_units
Map a number into a tuple of 1fr units primarily used to make optional column passing to #multiple_choice easier input = 3 -> output = (1fr, 1fr, 1fr) input = 5 -> output = (1fr, 1fr, 1fr, 1fr, 1fr)
### Parameters: 
num: `int`  number to map 
 
### Returns: 
`array`: Array of num fr units 


## multiple_choice
Create a multiple choice question
### Parameters: 
body: `content`  Body of question 
 
points: `int` (default: 1) Points the question is worth 
 
cols: `int | array` (default: 1) Number of columns to render the answer. Pass an array of units for specific spacing e.g. (1fr, 1fr, 12pt) 
 


## matching
Create a matching question e.g Cat      A. Canine Dog      B. Feline Fish     C. Aquatic Create
### Parameters: 
q_body: `content`  body of question to ask 
 
left_opts: `array`  options for the left side of question 
 
right_opts: `array`  options for the right side of question 
 
points: `int` (default: 1) points the question is worth 
 


## short_answer
Create a short answer question
### Parameters: 
q_body: `content`  Question Body 
 
lines: `int` (default: 1) lines of space to give the user, renders as actual lines 
 
points: `int` (default: 1) points the question is worth 
 


## free_response
Create a free response question
### Parameters: 
q_body: `content`  Question Body 
 
lines: `int` (default: 1) lines of space to give the user, renders as empty space 
 
points: `int` (default: 1) points the question is worth 
 


## code_block
Create a code block formatted for exams Wraps in box to the edge of the code, can add white space if need it to be longer
### Parameters: 
raw_code: `content(raw)`  raw code block, eg. ``````java public class...`````` 
 

