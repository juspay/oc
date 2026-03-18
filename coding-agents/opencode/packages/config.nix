{ pkgs, settings ? import ../juspay/settings.nix }:
let
  jsonFormat = pkgs.formats.json { };
in
jsonFormat.generate "opencode.json" ({
  "$schema" = "https://opencode.ai/config.json";
} // settings)
