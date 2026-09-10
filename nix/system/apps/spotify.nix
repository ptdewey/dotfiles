{ pkgs, ... }:
let
  spotify-sandboxed = pkgs.buildFHSEnv {
    name = "spotify";
    targetPkgs = pkgs: [ pkgs.spotify ];
    runScript = "spotify --enable-features=UseOzonePlatform --ozone-platform=wayland %U";
    extraBwrapArgs = [
      "--unshare-pid"
      "--unsthare-uts"
    ];
  };
in
{
  environment.systemPackages = [ spotify-sandboxed ];
}
