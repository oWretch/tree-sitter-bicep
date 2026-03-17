package tree_sitter_bicep_test

import (
	"testing"

	tree_sitter "github.com/tree-sitter/go-tree-sitter"
	tree_sitter_bicep "github.com/tree-sitter-grammars/tree-sitter-bicep/bindings/go"
)

func TestCanLoadBicepGrammar(t *testing.T) {
	language := tree_sitter.NewLanguage(tree_sitter_bicep.LanguageBicep())
	if language == nil {
		t.Errorf("Error loading Bicep grammar")
	}
}

func TestCanLoadBicepParamsGrammar(t *testing.T) {
	language := tree_sitter.NewLanguage(tree_sitter_bicep.LanguageBicepParams())
	if language == nil {
		t.Errorf("Error loading Bicep Params grammar")
	}
}
