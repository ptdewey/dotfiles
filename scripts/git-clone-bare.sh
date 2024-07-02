#!/usr/bin/env bash

git-clone-bare() {
    if [[ "$#" -lt 1 ]]; then
        echo "Usage: ./git-clone-bare.sh <repo-url> {repo-name}"
        return
    fi

    dir=$([ -z "${2}" ] && basename "${1}" || echo "${2}")
    git clone "${1}" "${dir}"
    cd "${dir}" || return
    git checkout "$(git commit-tree "$(git hash-object -t tree /dev/null)" < /dev/null)"
}
