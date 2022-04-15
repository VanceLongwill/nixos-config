{ pkgs, ... }:

{
  environment.pathsToLink = [ "/share/zsh" ];

  users.users.vance = {
    isNormalUser = true;
    home = "/home/vance";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.zsh;
    initialPassword = "test";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDP6vXWhxD5DwfMIQXNZtlGB2VYpyuWcDFD9Ip3XtTqB vance@Vances-MacBook-Pro.local"
    ];
  };

  nixpkgs.overlays = import ../../lib/overlays.nix ++ [
    (import ./vim.nix)
  ];
}
