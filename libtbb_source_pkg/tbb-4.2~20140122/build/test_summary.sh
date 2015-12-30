#!/bin/sh

# Rather than fail on first test, we keep a tally of tests that
# pass/fail; as some are running unpredictably on some systems.

# We do fail if we can't compile a test.

if [ "$1" = "--dump" ]; then
    if [ -e "$3/tests.passed" ]; then
        count=$(wc -l "$3/tests.passed" | awk '{print $1}')
        echo $count $2 tests passed.
    fi

    if [ -e "$3/tests.failed" ]; then
        echo The following $2 tests FAILED!
        cat "$3/tests.failed"
    fi

    exit 0
fi

eval $@
rc=$?

if [ "$rc" -eq "0" ]; then
    echo "$@" >> tests.passed
else
    echo "$@" >> tests.failed
fi

exit 0 # always succeed
