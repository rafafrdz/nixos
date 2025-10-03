{
  description = "My Custom NixOS flake";

  inputs = {
    # NixOS 25.05
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    # Nix Flakes from Community
    # VS Code Server (nix-community)
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = { self, nixpkgs, vscode-server, ... }@inputs: {
    nixosConfigurations.server = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix

        # Modulos
        vscode-server.nixosModules.default

        # Ajustes locales
        ({ config, pkgs, ... }: {
          services.vscode-server.enable = true;
        })
      ];
    };
  };
}
