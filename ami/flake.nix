{ outputs = { nixpkgs, ... }:
    import "${nixpkgs}/nixos/modules/virtualisation/amazon-ec2-amis.nix";
}
