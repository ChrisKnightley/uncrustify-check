#!/bin/bash

# exit if any errors occur
set -e

# change to source code directory
cd "$GITHUB_WORKSPACE"

git config --global --add safe.directory "$GITHUB_WORKSPACE"

FILE_SELECTOR="$(echo '*.cs' '*.c' '*.cpp' '*.h' '*.hpp' '*.m' '*.mm' '*.M')"
FILES_CHANGED="$(git diff --name-only --diff-filter= -- $FILE_SELECTOR)"

PATHS=$(echo $INPUT_CHECKEDPATHS | tr ";" "\n")

fail=0

# run checks on changed files
for FILE in $FILES_CHANGED
do

    check=1
    for P in $PATHS
    do
        check=0
        D=`dirname "$FILE"`
        if [[ "$D/" =~ ^$P/.* ]]
        then
            check=1
            break
        fi
    done

    if [ $check -eq 1 ]
    then
        if ! uncrustify -c "${INPUT_CONFIGFILE}" --check "${FILE}"
        then
            echo "Failed file ${FILE}"
            fail=1
        else
            echo "Passed file ${FILE}"
        fi
    else
        echo "Skipped file ${FILE}"
    fi
done

echo "CONFIG PATH: $INPUT_CONFIGFILE"
echo "CHECKED PATHS: $INPUT_CHECKEDPATHS"
echo "CURRENT BRANCH: $GITHUB_HEAD_REF"
echo "DEFAULT BRANCH: $GITHUB_BASE_REF"
echo "FILE SELECTOR: $FILE_SELECTOR"
echo "FILES CHANGED: $FILES_CHANGED"
git branch -a

exit $fail
