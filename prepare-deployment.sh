# a script to prepare all necessary files for deployment
# this is mostly so i stop forgetting things or rename them incorrectly

# please update paths if necessary
# specifically if any new files are added that wil need deployed, 
# they will also need added here

echo "Please ensure your package fork is synced with the upstream before continuing"
echo "git reset --hard is recommended"
read -p "Is your package updated? (y/n): " reply
if [[ "$reply" != "y" && "$reply" != "Y" ]]; then
    echo "Exiting..."
    exit 1
fi


PACKAGE_PATH="../typst-packages/packages/preview/codepoint"

read -r -p "Enter new version: " semver

echo "Creating codepoint:$semver"


mkdir -p "$PACKAGE_PATH/$semver"

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
    mkdir -p "$PACKAGE_PATH/$semver/$dir" 
done

for file in "${NEEDED_FILES[@]}"; do
    cp $file "$PACKAGE_PATH/$semver/$file"
done

echo "Successfully copied over necessary file"
echo "Please verify no files were missed"