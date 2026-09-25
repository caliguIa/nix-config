{ inputs, ... }:
{
    flake.modules.nixos.sway =
        { pkgs, ... }:
        let
            # DMS only loads a plugin once plugin_settings.json marks it enabled.
            # Add that when the entry is missing; anything set in DMS's UI is kept.
            enableScreenRecorder = pkgs.writeShellScript "dms-enable-screen-recorder" ''
                set -eu
                target="$HOME/.config/DankMaterialShell/plugin_settings.json"
                mkdir -p "$(dirname "$target")"
                [ -s "$target" ] || echo '{}' > "$target"
                ${pkgs.jq}/bin/jq '.screenRecorder //= {enabled: true}' "$target" > "$target.tmp"
                mv "$target.tmp" "$target"
            '';
        in
        {
            # gpu-screen-recorder behind a DMS bar widget, Control Center toggle and
            # `dms ipc call screenRecorder ...`. Settings live in DMS's plugin UI.
            programs.dank-material-shell.plugins.screenRecorder.src = inputs.dms-screen-recorder;

            # Also installs the capability wrapper needed for direct screen capture.
            programs.gpu-screen-recorder.enable = true;

            systemd.user.services.dms.serviceConfig.ExecStartPre = [ "${enableScreenRecorder}" ];
        };
}
