{ pkgs }:

# Go-based MPRIS media status + control binary for the waybar `custom/media`
# module. Built from source in this directory; vendorHash is derived from
# go.sum. To refresh the hash after dependency changes, set vendorHash to
# pkgs.lib.fakeHash, run `nixos-rebuild build`, and paste the "got:" sha.
pkgs.buildGoModule {
  pname = "mediaplayer";
  version = "0.1.0";

  src = ./.;

  # Computed from go.sum; see note above if deps change.
  vendorHash = "sha256-Ac63bZlBvCrhS7b8mk7aJdApI8UGtJxnZG35L37roGY=";

  # The module is a single main package at the repo root.
  subPackages = [ "." ];

  # Runtime dep: nothing beyond the Go binary itself (talks to the session
  # bus over DBus, no CGO/GObject needed).
}
