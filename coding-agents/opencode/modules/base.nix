{ config, lib, pkgs, ... }:
{
  programs.opencode = {
    enable = true;
    settings = import ../settings-base.nix;
  };
}
