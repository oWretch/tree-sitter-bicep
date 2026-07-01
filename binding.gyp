{
  "targets": [
    {
      "target_name": "tree_sitter_bicep_binding",
      "dependencies": [
        "<!(node -p \"require('node-addon-api').targets\"):node_addon_api_except",
      ],
      "include_dirs": [
        "bicep/src",
      ],
      "sources": [
        "bicep/src/parser.c",
        "bicep/src/scanner.c",
        "bicep_params/src/parser.c",
        "bicep_params/src/scanner.c",
        "bindings/node/binding.cc",
      ],
      "conditions": [
        ["OS!='win'", {
          "cflags_c": [
            "-std=c11",
          ],
        }, { # OS == "win"
          "cflags_c": [
            "/std:c11",
            "/utf-8",
          ],
        }],
      ],
    }
  ]
}
