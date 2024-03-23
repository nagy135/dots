{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect
    ./host.nix
  ];
  programs.zsh.enable = true;

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "nixos";
  networking.domain = "";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [ ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCnmNqABy0voX/rDdThGadpR5ZSF6NWJ2oWaGJvRJWF4H1PZHVJr/BSl/s7zQM5Tp4PH34+g8CNZAaFFP5aThGDv22cIAlZneM5t5HL0iHiN9/L9e9W3U7ySLDYdRls0QBnURUInNh8pK6IqqJTg8LDx6kfxOBhJyPtlLFhxqWtJSYTjm17B/tU8bvtslbg97Q1ck89VVX1g++2YCjOGhZv0HKp7X3F6RvTlJolYxUwvZ4qPdx2eXSWgSLAYJc7aDlJLdqEqPqA1senvcIYam+cWkxqnmEobIhmc4oDSnLO/Yf5vRANP/tw7VPgf9kxnXa7OEhbEt++Uts+FidZZC/xFnT9x2Rp8I/5MGLn52y5QPmSm3KTPSxBkFuzLA93opjOIiijov5EECZhtsWWN4z97rSeBu11OMXcbTKPTPCjOWxylDW83xFx6gl6/lmu5UirbRGqoOlzOoV2hrLy/MlOXX9lDU5LtlZShId4hbzt/lkctv7AcnE9QTSU/8651d8= infiniter@infiniter'' ];
  users.users.infiniter = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "docker" "video" "podman" ];
    openssh.authorizedKeys.keys = [ ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCnmNqABy0voX/rDdThGadpR5ZSF6NWJ2oWaGJvRJWF4H1PZHVJr/BSl/s7zQM5Tp4PH34+g8CNZAaFFP5aThGDv22cIAlZneM5t5HL0iHiN9/L9e9W3U7ySLDYdRls0QBnURUInNh8pK6IqqJTg8LDx6kfxOBhJyPtlLFhxqWtJSYTjm17B/tU8bvtslbg97Q1ck89VVX1g++2YCjOGhZv0HKp7X3F6RvTlJolYxUwvZ4qPdx2eXSWgSLAYJc7aDlJLdqEqPqA1senvcIYam+cWkxqnmEobIhmc4oDSnLO/Yf5vRANP/tw7VPgf9kxnXa7OEhbEt++Uts+FidZZC/xFnT9x2Rp8I/5MGLn52y5QPmSm3KTPSxBkFuzLA93opjOIiijov5EECZhtsWWN4z97rSeBu11OMXcbTKPTPCjOWxylDW83xFx6gl6/lmu5UirbRGqoOlzOoV2hrLy/MlOXX9lDU5LtlZShId4hbzt/lkctv7AcnE9QTSU/8651d8= infiniter@infiniter'' ];
  };
  environment.systemPackages = [
    pkgs.arion

    # Do install the docker CLI to talk to podman.
    # Not needed when virtualisation.docker.enable = true;
    pkgs.docker-compose
    pkgs.git
    pkgs.docker-client
  ];

  # Arion works with Docker, but for NixOS-based containers, you need Podman
  # since NixOS 21.05.
  virtualisation.docker.enable = true;
  #  virtualisation.podman.enable = true;
  #  virtualisation.podman.dockerSocket.enable = true;
  #
  #  virtualisation.podman.defaultNetwork.settings.dns_enabled = true;

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "3dprints" ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
    '';
  };

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 8 * 1024;
  }];

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  security.acme = {
    acceptTerms = true;

    defaults.email = "viktor.nagy1995@gmail.com";
  };


  services.nginx.enable = true;
  services.nginx.virtualHosts =
    let
      SSL = {
        enableACME = true;
        forceSSL = true;
      }; in
    {
      "3d-api.infiniter.tech" = (SSL // {
        locations."/".proxyPass = "http://127.0.0.1:13000/";
        serverAliases = [
          "www.3d-api.infiniter.tech"
        ];
      });

      "3d.infiniter.tech" = (SSL // {
        locations."/".proxyPass = "http://127.0.0.1:3000/";
        serverAliases = [
          "www.3d.infiniter.tech"
        ];
      });
    };

  system.stateVersion = "23.11";
}
