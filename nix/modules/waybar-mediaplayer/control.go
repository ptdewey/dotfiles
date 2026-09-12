package main

import (
	"fmt"
	"os"

	"github.com/godbus/dbus/v5"
)

// runControl performs a one-shot media action against the active player and
// exits. The long-running watcher (if any) will observe the resulting
// PropertiesChanged signal and update on its own, so no IPC is needed.
func runControl(action string) int {
	conn, err := dbus.SessionBus()
	if err != nil {
		fmt.Fprintln(os.Stderr, "mediaplayer: session bus:", err)
		return 1
	}
	defer conn.Close()

	tr := newTracker(conn)
	if err := tr.loadAll(); err != nil {
		fmt.Fprintln(os.Stderr, "mediaplayer: discover:", err)
		return 1
	}

	busName, ok := tr.activePlayer()
	if !ok {
		// No player to control; exit silently.
		return 0
	}

	method, ok := actionMethod(action)
	if !ok {
		fmt.Fprintf(os.Stderr, "mediaplayer: unknown action %q\n", action)
		fmt.Fprintf(os.Stderr, "usage: %s [play-pause|next|previous|play|stop|pause]\n", os.Args[0])
		return 2
	}

	obj := playerObject(conn, busName)
	if err := obj.Call(mprisPlayerIface+"."+method, 0).Err; err != nil {
		// Non-fatal: the player may have just vanished. Don't spam waybar.
		fmt.Fprintln(os.Stderr, "mediaplayer:", err)
		return 0
	}
	return 0
}

// actionMethod maps a user-facing action to the MPRIS Player method name.
func actionMethod(action string) (string, bool) {
	switch action {
	case "play-pause", "play_pause", "toggle":
		return "PlayPause", true
	case "next":
		return "Next", true
	case "previous", "prev":
		return "Previous", true
	case "play":
		return "Play", true
	case "stop":
		return "Stop", true
	case "pause":
		return "Pause", true
	default:
		return "", false
	}
}
