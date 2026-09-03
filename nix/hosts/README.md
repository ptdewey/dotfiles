# Home Manager hosts

The repository currently exports reusable Home Manager modules. Host-specific
composition lives in the consuming system flake: Europa is embedded by `~/nixos`,
while a future Darwin host will be added here once its machine facts are known.

The eventual host layout will use explicit composition roots under
`nix/hosts/<platform>/<host>/`.

Host-specific public exceptions belong in the host module. Private runtime
configuration stays outside the flake, and private NixOS configuration remains
in the separate system flake.
