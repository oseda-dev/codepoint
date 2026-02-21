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