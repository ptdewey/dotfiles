package main

import (
	"sort"

	"github.com/godbus/dbus/v5"
)

// tracker keeps the current set of known players and decides which one to
// display. Selection policy mirrors the reference playerctl Python tool:
// prefer the first Playing player (most recently added wins on ties), else
// show the first known player, else show nothing.
type tracker struct {
	// known holds the ordered list of player bus names we currently track.
	// We preserve insertion order so "first" is stable; newly appeared names
	// are appended and removed names are spliced out.
	known []string
	conn  *dbus.Conn
}

func newTracker(conn *dbus.Conn) *tracker {
	return &tracker{conn: conn}
}

// add registers a player if not already known. Returns true if added.
func (t *tracker) add(busName string) bool {
	for _, n := range t.known {
		if n == busName {
			return false
		}
	}
	t.known = append(t.known, busName)
	return true
}

// remove drops a player, returning true if it was present.
func (t *tracker) remove(busName string) bool {
	for i, n := range t.known {
		if n == busName {
			t.known = append(t.known[:i], t.known[i+1:]...)
			return true
		}
	}
	return false
}

// current returns the best track to display and whether anything is showing.
// It probes every known player for status/metadata and picks the winner.
// Players that fail to respond are pruned.
func (t *tracker) current() (track, bool) {
	var tracks []track
	for _, name := range t.known {
		tr, ok, err := readTrack(t.conn, name)
		if err != nil || !ok {
			continue
		}
		tracks = append(tracks, tr)
	}
	if len(tracks) == 0 {
		return track{}, false
	}
	// Rebuild known list from the players that actually responded, keeping
	// the original order.
	alive := make([]string, 0, len(tracks))
	for _, name := range t.known {
		for _, tr := range tracks {
			if tr.busName == name {
				alive = append(alive, name)
				break
			}
		}
	}
	t.known = alive

	// Prefer the first Playing player; among those, the most recently added
	// (i.e. last in insertion order) wins, matching the Python tool's
	// reversed-scan behavior.
	for i := len(tracks) - 1; i >= 0; i-- {
		if tracks[i].status == "Playing" {
			return tracks[i], true
		}
	}
	// Stable sort by bus name for deterministic fallback when nothing plays.
	sort.SliceStable(tracks, func(i, j int) bool { return tracks[i].busName < tracks[j].busName })
	return tracks[0], true
}

// activePlayer returns the bus name the controller should target. It is the
// same player current() would display: first Playing, else first known.
func (t *tracker) activePlayer() (string, bool) {
	tr, ok := t.current()
	return tr.busName, ok
}

// loadAll discovers current players and registers them.
func (t *tracker) loadAll() error {
	names, err := playerNames(t.conn)
	if err != nil {
		return err
	}
	for _, n := range names {
		t.add(n)
	}
	return nil
}
