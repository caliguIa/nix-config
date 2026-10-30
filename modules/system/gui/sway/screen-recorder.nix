{ inputs, ... }:
{
    flake.modules.nixos.gui =
        { pkgs, ... }:
        let
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
            programs.dank-material-shell.plugins.screenRecorder.src = inputs.dms-screen-recorder;
            # Plain package: the plugin records via the portal, so the
            # cap_sys_admin gsr-kms-server wrapper isn't needed.
            environment.systemPackages = [ pkgs.gpu-screen-recorder ];
            systemd.user.services.dms.serviceConfig.ExecStartPre = [ "-${enableScreenRecorder}" ];
        };
}
