{ writeShellScriptBin
, example-shell-lib
}:

writeShellScriptBin "example-shell"
    ''
    . ${example-shell-lib}
    do_with_header hello "$@"
    ''