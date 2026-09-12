package main

import (
	"fmt"
	"os"
	"os/signal"
	"syscall"

	"github.com/godbus/dbus/v5"
)

func main() {
	if len(os.Args) > 1 {
		os.Exit(runControl(os.Args[1]))
	}
	os.Exit(runWatcher())
}

// runWatcher is the long-running mode: it discovers MPRIS players, subscribes
// to DBus signals, and prints one waybar JSON line whenever the displayed
// state changes.
func runWatcher() int {
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

	// Subscribe to PropertiesChanged for any player on the standard MPRIS path.
	if err := conn.AddMatchSignal(
		dbus.WithMatchObjectPath("/org/mpris/MediaPlayer2"),
		dbus.WithMatchInterface(propertiesIface),
	); err != nil {
		fmt.Fprintln(os.Stderr, "mediaplayer: AddMatch PropertiesChanged:", err)
		return 1
	}
	// Subscribe to NameOwnerChanged to learn about players appearing/vanishing.
	if err := conn.AddMatchSignal(
		dbus.WithMatchInterface(dbusIface),
		dbus.WithMatchMember("NameOwnerChanged"),
	); err != nil {
		fmt.Fprintln(os.Stderr, "mediaplayer: AddMatch NameOwnerChanged:", err)
		return 1
	}

	sigCh := make(chan *dbus.Signal, 64)
	conn.Signal(sigCh)

	// Render the initial state immediately.
	refresh(tr)

	sig := make(chan os.Signal, 1)
	signal.Notify(sig, syscall.SIGINT, syscall.SIGTERM, syscall.SIGPIPE)

	for {
		select {
		case s, ok := <-sigCh:
			if !ok {
				// Connection closed.
				printLine(renderEmpty())
				return 0
			}
			if handleSignal(tr, s) {
				refresh(tr)
			}
		case <-sig:
			// On exit, clear the module so waybar doesn't leave stale text.
			printLine(renderEmpty())
			return 0
		}
	}
}

// handleSignal inspects a DBus signal and reports whether the displayed state
// may have changed (and thus needs a refresh). It also mutates the tracker's
// known-player set on NameOwnerChanged.
func handleSignal(tr *tracker, s *dbus.Signal) bool {
	switch s.Name {
	case propertiesChanged:
		// Only care about player property changes on the MPRIS path.
		if s.Path != mprisObjectPath {
			return false
		}
		// Body: [interface string, changed map, invalidated []string].
		if len(s.Body) > 0 {
			if iface, ok := s.Body[0].(string); ok && iface != mprisPlayerIface && iface != mprisRootIface {
				return false
			}
		}
		return true
	case nameOwnerChanged:
		// Body: [name, oldOwner, newOwner].
		if len(s.Body) < 3 {
			return false
		}
		name, ok := s.Body[0].(string)
		if !ok || !isMPRISName(name) {
			return false
		}
		oldOwner, _ := s.Body[1].(string)
		newOwner, _ := s.Body[2].(string)
		appeared := newOwner != ""
		vanished := oldOwner != ""
		if appeared {
			tr.add(name)
		}
		if vanished && !appeared {
			tr.remove(name)
		}
		return true
	}
	return false
}

// refresh recomputes the current display state and prints it.
func refresh(tr *tracker) {
	t, ok := tr.current()
	printLine(renderLine(t, ok))
}

func isMPRISName(name string) bool {
	return len(name) > len(mprisNamePrefix) && name[:len(mprisNamePrefix)] == mprisNamePrefix
}
