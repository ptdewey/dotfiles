# Home Manager hosts

Hosts are organized by platform under `nix/hosts/<platform>/<host>/`. Each
host directory is an explicit composition root that imports the shared Patrick
Home Manager module.

Host-specific public exceptions belong in the host module. Private runtime
configuration stays outside the flake, and private NixOS configuration remains
in the separate system flake.
