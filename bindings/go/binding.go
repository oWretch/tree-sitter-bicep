package tree_sitter_bicep

// #cgo CPPFLAGS: -I../../bicep/src
// #cgo CFLAGS: -std=c11 -fPIC
// #include "../../bicep/src/parser.c"
// #include "../../bicep/src/scanner.c"
import "C"

import "unsafe"

// Get the tree-sitter Language for Bicep.
func LanguageBicep() unsafe.Pointer {
	return unsafe.Pointer(C.tree_sitter_bicep())
}
