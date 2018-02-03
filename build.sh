#!/bin/bash
set -o pipefail

root_dir=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
build_log="$root_dir/build.log"
echo >$build_log

for editor in $(ls -1 "$root_dir/builds/"); do
    test -d "$root_dir/builds/$editor" || continue
    for build in $(ls -1 "$root_dir/builds/$editor/"); do
        test -x "$root_dir/builds/$editor/$build" || continue
        editor_build="${editor}_${build}";
        echo -n "Building $editor_build... "
        export EDITOR_INSTALL_DIR="$root_dir/workspace/$editor_build"
        export EDITOR_BIN_PATH="$root_dir/workspace/$editor_build/$editor_build"
        export EDITOR_REPO="$root_dir/editors/$editor"
        (cd $EDITOR_REPO && \
            mkdir -p $EDITOR_INSTALL_DIR && \
            "$root_dir/builds/$editor/$build" >>$build_log 2>&1 && \
            test -x $EDITOR_BIN_PATH)
        echo "exit_code=$?"
    done
done
