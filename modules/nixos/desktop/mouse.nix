{
    flake.modules.darwin.system-desktop-mouse = {
        system = {
            defaults = {
                trackpad = {
                    Clicking = false;
                    Dragging = false;
                    ActuationStrength = 1;
                    TrackpadThreeFingerDrag = false;
                };
                NSGlobalDomain = {
                    "com.apple.mouse.tapBehavior" = null;
                    AppleEnableMouseSwipeNavigateWithScrolls = false;
                    AppleEnableSwipeNavigateWithScrolls = false;
                };
            };
        };
    };

    flake.modules.nixos.system-desktop-mouse = {};
}
