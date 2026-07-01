# a script to prepare all necessary files for deployment
# this is mostly so i stop forgetting things or rename them incorrectly

# please update paths if necessary
# specifically if any new files are added that wil need deployed, 
# they will also need added here


PACKAGE_PATH="../typst-packages/packages/preview/codepoint"

read -r -p "Enter new version: " semver

echo "typed: $semver"

NEEDED_DIRECTORIES=(
    "src"
    "themes"
    "img"
)

NEEDED_FILES=(
    "lib.typ"
    "typst.toml"
    "src/labs.typ"
    "src/exams.typ"
    "README.md"
    "themes/codepoint.tmTheme"
    "LICENSE"
    "img/logo.png"
    "img/lab.png"
    "img/exam.png"
)

for dir in "${NEEDED_DIRECTORIES[@]}"; do
    mkdir -p $file
done

for file in "${NEEDED_FILES[@]}"; do
    cp $file "$PACKAGE_PATH/$file"
done