#!bash
#based on default git pre-commit hook
if git rev-parse --verify HEAD >/dev/null 2>&1
then
        against=HEAD
else
        # Initial commit: diff against an empty tree object
        against=$(git hash-object -w -t tree /dev/null)
fi
source TAP.sh "$(basename $0)" 4
is "$(git diff --name-only --cached --diff-filter=A -z "$against" | LC_ALL=C tr -d '[ -~]\0' | wc -c)" 0 'staged ASCII filenames'
is "$(git diff --name-only --diff-filter=A -z "$against" | LC_ALL=C tr -d '[ -~]\0' | wc -c)" 0 'ASCII filenames'
git diff-index --check --cached $against -- >&2
wasok 'staged whitespace'
git diff-index --check $against -- >&2
wasok 'whitespace'
endtests
