{
    writeShellApplication,
    nodejs,
    vscode-extensions,
}:
writeShellApplication {
    name = "stylelint-language-server";
    runtimeInputs = [ nodejs ];
    text =
        let
            ext = vscode-extensions.stylelint.vscode-stylelint;
        in
        ''exec node ${ext}/share/vscode/extensions/stylelint.vscode-stylelint/dist/start-server.js "$@"'';
}
