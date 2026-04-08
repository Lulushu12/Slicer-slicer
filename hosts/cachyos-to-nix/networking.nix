{ config, pkgs, lib, ... }:
  # Network settings
  networking.hostName = "CachyOS-Desktop";
  networking.useDHCP = true;

  # Enable NetworkManager
  networking.networkmanager = {
    enable = true;
    # Use systemd-resolved instead of dnsmasq (lighter)
    dns = "systemd";
  };

  # Firewall settings
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];  # SSH
    # Add more as needed
  };

  # OpenSSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
