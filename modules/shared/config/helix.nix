{ pkgs, lib, ... }: {
  enable = true;
  extraPackages = with pkgs; [
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages.yaml-language-server
    nodePackages.bash-language-server
    taplo
    rust-analyzer
    marksman
  ];
  settings = {
    theme = "base16_transparent";

    editor = {
      line-number = "relative";
      completion-trigger-len = 1;
      bufferline = "multiple";
      color-modes = true;
      statusline = {
        left = [
          "mode"
          "spacer"
          "diagnostics"
          "version-control"
          "file-name"
          "read-only-indicator"
          "file-modification-indicator"
          "spinner"
        ];
        right = [ "file-encoding" "file-type" "selections" "position" ];
      };
      cursor-shape.insert = "bar";
      whitespace.render.tab = "all";
      indent-guides = {
        render = true;
        character = "┊";
      };
    };
  };
  languages.language = let
    prettier = {
      command = lib.getExe pkgs.nodePackages.prettier;
      args = lib.cli.toGNUCommandLine { } { w = true; };
    };
    jsRoots = [
      "package.json"
      "package-lock.json"
      "yarn.lock"
      "deno.json"
      "deno.lock"
      "bun.lockb"
    ];
  in [
    {
      name = "javascript";
      roots = jsRoots;
      formatter = prettier;
      auto-format = true;
    }
    {
      name = "typescript";
      roots = jsRoots;
      formatter = prettier;
      auto-format = true;
    }
    {
      name = "markdown";
      formatter = prettier;
      auto-format = true;
    }
    {
      name = "nix";
      roots = [ "flake.nix" "flake.lock" ];
      auto-format = true;
      language-servers = [ "nixd" ];
    }
  ];
  themes = {
    tokyonight = {

    };
  };
}
