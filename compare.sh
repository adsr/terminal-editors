#!/bin/bash
set -o pipefail

root_dir=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
compare_log="$root_dir/compare.log"
echo >$compare_log

export EDITOR_TOOLS_DIR="$root_dir/tools"
for feature in $(ls -1 "$root_dir/features/"); do
    test -x "$root_dir/features/$feature" || continue
    echo "Comparing $feature... "
    for editor_build in $(ls -1 "$root_dir/workspace/"); do
        editor=$(echo $editor_build | cut -d_ -f1)
        export EDITOR_BIN_PATH="$root_dir/workspace/$editor_build/$editor_build"
        export EDITOR_REPO="$root_dir/editors/$editor"
        export EDITOR_NAME="$editor"
        test -x $EDITOR_BIN_PATH || continue
        test -d $EDITOR_REPO || continue
        echo -n "    $editor_build... "
        result=$("$root_dir/features/$feature" 2>>$compare_log | head -n1)
        echo "exit_code=$?; result=$result"
    done
done
