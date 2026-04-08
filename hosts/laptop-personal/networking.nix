{ config, pkgs, lib, ... }:
{
  networking.hostName = "laptop-personal";
  networking.useDHCP = true;
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "systemd";

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
