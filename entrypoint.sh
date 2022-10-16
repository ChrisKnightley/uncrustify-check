#!/bin/sh

# exit if any errors occur
set -e;

# change to source code directory
cd "$GITHUB_WORKSPACE";

git config --global --add safe.directory "$GITHUB_WORKSPACE"

FILE_SELECTOR="$(echo '*.cs' '*.c' '*.cpp' '*.h' '*.hpp' '*.m' '*.mm' '*.M')"
FILES_CHANGED="$(git diff --name-only --diff-filter=AM HEAD^ -- $FILE_SELECTOR)"

# run checks on changed files
for FILE in $FILES_CHANGED; do
    uncrustify -c "${INPUT_CONFIGFILE}" --check "${FILE}";
done;

echo "CONFIG PATH: $INPUT_CONFIGFILE";
echo "CURRENT BRANCH: $GITHUB_HEAD_REF";
echo "DEFAULT BRANCH: $GITHUB_BASE_REF";
echo "FILE SELECTOR: $FILE_SELECTOR";
echo "FILES CHANGED: $FILES_CHANGED";
git branch -a;

exit 0;
