{
  imports = [ ../../../modules/patrick ];

  # Tracer host: this scaffold deliberately owns no existing dotfiles or
  # packages yet. Add one concern at a time after building successfully.
  dotfiles.enable = true;

  # Public, harmless host exceptions belong here. Private values belong in
  # ~/.config/dotfiles-local/ (runtime-loaded, never a Nix input).
}
