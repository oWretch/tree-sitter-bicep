package tree_sitter_bicep

// #cgo CPPFLAGS: -I../../bicep_params/src
// #cgo CFLAGS: -std=c11 -fPIC
// #include "../../bicep_params/src/parser.c"
// #include "../../bicep_params/src/scanner.c"
import "C"

import "unsafe"

// Get the tree-sitter Language for Bicep Params.
func LanguageBicepParams() unsafe.Pointer {
	return unsafe.Pointer(C.tree_sitter_bicep_params())
}
