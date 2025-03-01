#!/bin/bash

# Get the latest commit hash
latest_commit=$(git rev-parse HEAD)
if [ $? -ne 0 ]; then
    echo "Error obtaining the latest commit" >&2
    exit 1
fi

# Get the diff between main and the latest commit
diff_output=$(git diff main HEAD)
if [ $? -ne 0 ]; then
    echo "Error obtaining the diff" >&2
    exit 1
fi

# Escape the diff output using Python's json.dumps to ensure valid JSON formatting
escaped_diff=$(python3 -c "import sys, json; print(json.dumps(sys.stdin.read()))" <<<"$diff_output")

# Print out the JSON result
printf '{\n  "latest_commit": "%s",\n  "diff": %s\n}\n' "$latest_commit" "$escaped_diff"
