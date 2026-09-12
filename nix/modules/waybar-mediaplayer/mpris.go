package main

import (
	"fmt"
	"strings"

	"github.com/godbus/dbus/v5"
)

// MPRIS constants.
const (
	mprisNamePrefix    = "org.mpris.MediaPlayer2."
	mprisPlayerIface   = "org.mpris.MediaPlayer2.Player"
	mprisRootIface     = "org.mpris.MediaPlayer2"
	mprisObjectPath    = dbus.ObjectPath("/org/mpris/MediaPlayer2")
	propertiesIface    = "org.freedesktop.DBus.Properties"
	dbusIface          = "org.freedesktop.DBus"
	propertiesChanged  = propertiesIface + ".PropertiesChanged"
	nameOwnerChanged   = dbusIface + ".NameOwnerChanged"
)

// playerNames returns all MPRIS player bus names currently on the session bus.
func playerNames(conn *dbus.Conn) ([]string, error) {
	var names []string
	if err := conn.BusObject().Call(dbusIface+".ListNames", 0).Store(&names); err != nil {
		return nil, fmt.Errorf("ListNames: %w", err)
	}
	var players []string
	for _, n := range names {
		if strings.HasPrefix(n, mprisNamePrefix) && len(n) > len(mprisNamePrefix) {
			players = append(players, n)
		}
	}
	return players, nil
}

// identity returns the player identity (the part after the MPRIS prefix).
func identity(busName string) string {
	return strings.TrimPrefix(busName, mprisNamePrefix)
}

// playerObject returns the proxy object for a given player bus name.
func playerObject(conn *dbus.Conn, busName string) dbus.BusObject {
	return conn.Object(busName, mprisObjectPath)
}

// playbackStatus reads the PlaybackStatus property ("Playing"/"Paused"/"Stopped").
// Returns "" and a nil error if the player vanished mid-query.
func playbackStatus(conn *dbus.Conn, busName string) (string, error) {
	v, err := playerObject(conn, busName).GetProperty(mprisPlayerIface + ".PlaybackStatus")
	if err != nil {
		if isUnknownMethodOrService(err) {
			return "", nil
		}
		return "", err
	}
	s, _ := v.Value().(string)
	return s, nil
}

// track holds the display-relevant fields extracted from a player's metadata.
type track struct {
	busName  string
	player   string // identity
	status   string
	artist   string
	title    string
	album    string
	ad       bool
	artURL   string
	lengthUS int64
}

// readTrack reads the current playback status and metadata for a player.
// It never returns an error for a player that has vanished; those are skipped
// upstream. Missing fields yield zero values.
func readTrack(conn *dbus.Conn, busName string) (track, bool, error) {
	obj := playerObject(conn, busName)
	t := track{busName: busName, player: identity(busName)}

	st, err := playbackStatus(conn, busName)
	if err != nil {
		return t, false, err
	}
	t.status = st

	mv, err := obj.GetProperty(mprisPlayerIface + ".Metadata")
	if err != nil {
		if isUnknownMethodOrService(err) {
			return t, false, nil
		}
		return t, false, err
	}
	meta, ok := mv.Value().(map[string]dbus.Variant)
	if !ok {
		return t, true, nil
	}

	if v, ok := meta["xesam:title"]; ok {
		t.title, _ = v.Value().(string)
	}
	if v, ok := meta["xesam:album"]; ok {
		t.album, _ = v.Value().(string)
	}
	if v, ok := meta["xesam:artist"]; ok {
		switch a := v.Value().(type) {
		case []string:
			if len(a) > 0 {
				t.artist = a[0]
			}
		case string:
			t.artist = a
		}
	}
	if v, ok := meta["mpris:artUrl"]; ok {
		t.artURL, _ = v.Value().(string)
	}
	if v, ok := meta["mpris:length"]; ok {
		switch n := v.Value().(type) {
		case int64:
			t.lengthUS = n
		case uint64:
			t.lengthUS = int64(n)
		}
	}
	// Spotify exposes ads via a trackid containing ":ad:".
	if v, ok := meta["mpris:trackid"]; ok {
		if s, ok := v.Value().(string); ok && strings.Contains(s, ":ad:") {
			t.ad = true
		} else if op, ok := v.Value().(dbus.ObjectPath); ok && strings.Contains(string(op), ":ad:") {
			t.ad = true
		}
	}
	return t, true, nil
}

// isUnknownMethodOrService reports whether err indicates the player is gone or
// doesn't implement the property, so callers can treat it as "skip" rather than
// a fatal error.
func isUnknownMethodOrService(err error) bool {
	if err == nil {
		return false
	}
	s := err.Error()
	return strings.Contains(s, "org.freedesktop.DBus.Error.ServiceUnknown") ||
		strings.Contains(s, "org.freedesktop.DBus.Error.NoReply") ||
		strings.Contains(s, "org.freedesktop.DBus.Error.UnknownMethod") ||
		strings.Contains(s, "org.freedesktop.DBus.Error.UnknownObject") ||
		strings.Contains(s, "org.freedesktop.DBus.Error.UnknownInterface") ||
		strings.Contains(s, "org.freedesktop.DBus.Error.UnknownProperty")
}
