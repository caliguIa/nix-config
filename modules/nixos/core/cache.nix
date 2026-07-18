{user, ...}: {
    flake.modules.nixos.core = {
        nix.settings = {
            trusted-users = [
                "root"
                user.primary
                "@wheel"
            ];
            substituters = ["https://cache.nixos.org/"];
            extra-substituters = [
                "https://cache.garnix.io"
                "https://nix-community.cachix.org"
            ];
            extra-trusted-public-keys = [
                "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
                "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            ];
            fallback = true;
            connect-timeout = 15;
            stalled-download-timeout = 10;
            max-substitution-jobs = 16;
            http-connections = 25;
        };
    };
}
