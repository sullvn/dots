{
  description = "sullvn and blimp";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";

    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    home-manager-stable.url = "github:nix-community/home-manager/release-26.05";
    home-manager-stable.inputs.nixpkgs.follows = "nixpkgs-stable";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    # Pinned to the release branch matching nixpkgs-stable (was: master).
    nixvim-stable.url = "github:nix-community/nixvim/nixos-26.05";
    nixvim-stable.inputs.nixpkgs.follows = "nixpkgs-stable";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # No nixpkgs follows, to get the builds cached at cache.numtide.com
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs = inputs: {
    darwinConfigurations.sullvn = inputs.nix-darwin.lib.darwinSystem {
      specialArgs = { inherit inputs; };
      modules = [ ./hosts/sullvn ];
    };

    nixosConfigurations.blimp = inputs.nixpkgs-stable.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [ ./hosts/blimp ];
    };
  };
}
