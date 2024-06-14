#!/bin/bash

# custom pywal feh wallpaper setter
wal-fill() {
    wal -n -i "$@"
    feh --bg-fill "$(< "${HOME}/.cache/wal/wal")"
}

feh-fill() {
    feh --bg-fill "$(< "${HOME}/.cache/wal/wal")"
}
