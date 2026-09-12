package main

import (
	"encoding/json"
	"fmt"
	"strings"
)

// waybarOut is the JSON object printed for a waybar custom module with
// return-type "json". With "escape": true in the waybar config we emit plain
// text and waybar handles pango escaping.
type waybarOut struct {
	Text    string `json:"text"`
	Alt     string `json:"alt"`
	Tooltip string `json:"tooltip,omitempty"`
	Class   string `json:"class"`
}

// statusIcon maps an MPRIS playback status to a Nerd Font glyph. Codepoints
// use the Nerd Font Private Use Area so they render regardless of which icon
// font family waybar is configured to use.
func statusIcon(status string) string {
	switch status {
	case "Playing":
		return "\uf04b" // play triangle
	case "Paused":
		return "\uf04c" // pause bars
	default:
		return "\uf04d" // stop square
	}
}

// formatTrack builds the display text and tooltip for a track.
func formatTrack(t track) waybarOut {
	player := t.player
	if player == "" {
		player = "media"
	}
	out := waybarOut{
		Alt:   player,
		Class: "custom-" + player,
	}

	icon := statusIcon(t.status)

	var text string
	switch {
	case t.ad:
		text = "Advertisement"
	case t.artist != "" && t.title != "":
		text = t.artist + " - " + t.title
	case t.title != "":
		text = t.title
	case t.artist != "":
		text = t.artist
	default:
		// No usable metadata: show the player + status so the module isn't blank.
		if t.status != "" {
			text = player
		}
	}

	if text != "" {
		out.Text = strings.TrimSpace(icon + " " + text)
		// Tooltip: artist - title on line 1, album on line 2 if present.
		var tip string
		if t.artist != "" && t.title != "" {
			tip = t.artist + " - " + t.title
		} else if t.title != "" {
			tip = t.title
		} else {
			tip = player
		}
		if t.album != "" {
			tip += "\n" + t.album
		}
		out.Tooltip = tip
	} else {
		out.Text = ""
	}
	return out
}

// renderLine marshals a track to a single JSON line for waybar.
// An empty track renders an empty-text object so the module hides cleanly.
func renderLine(t track, ok bool) string {
	if !ok {
		return renderEmpty()
	}
	b, err := json.Marshal(formatTrack(t))
	if err != nil {
		return renderEmpty()
	}
	return string(b)
}

// renderEmpty prints a JSON object with empty text, clearing the module.
func renderEmpty() string {
	return `{"text":"","alt":"","class":""}`
}

// printLine writes one line to stdout and flushes. Waybar reads one JSON object
// per line from the long-running exec process.
func printLine(s string) {
	fmt.Println(s)
}
