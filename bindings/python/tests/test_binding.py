from unittest import TestCase

import tree_sitter, tree_sitter_bicep


class TestLanguage(TestCase):
    def test_can_load_bicep_grammar(self):
        try:
            tree_sitter.Language(tree_sitter_bicep.language_bicep())
        except Exception:
            self.fail("Error loading Bicep grammar")

    def test_can_load_bicep_params_grammar(self):
        try:
            tree_sitter.Language(tree_sitter_bicep.language_bicep_params())
        except Exception:
            self.fail("Error loading Bicep Params grammar")
