#!/usr/bin/env bash

git-clone-bare() {
    # check for correct number of arguments
    if [[ "$#" -lt 1 ]]; then
        echo "Usage: ./git-clone-bare.sh <repo-url> {repo-name}"
        return
    fi

    # append .git to baseneame call to get rid of extension
    dir=$([ -z "${2}" ] && basename "${1}" || echo "${2}")

    ## Option 1: clone repo in bare state and correct fetch behavior
    git clone "${1}" "${dir}" --bare
    cd "${dir}" || return
    git config remote.origin.url "${1}"
    git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
    git fetch

    ## Option 2: leave an empty directory with detached HEAD
    # git clone "${1}" "${dir}"
    # git checkout "$(git commit-tree "$(git hash-object -t tree /dev/null)" < /dev/null)"
    # cd "${dir}" || return
}
