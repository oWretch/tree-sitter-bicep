from unittest import TestCase

import tree_sitter, tree_sitter_bicep


class TestLanguage(TestCase):
    def test_can_load_grammar(self):
        try:
            tree_sitter.Language(tree_sitter_bicep.language())
        except Exception:
            self.fail("Error loading Bicep grammar")

    def test_outline_query_available(self):
        """Test that the outline query is available and contains expected content."""
        outline_query = tree_sitter_bicep.OUTLINE_QUERY
        self.assertIsInstance(outline_query, str)
        self.assertIn("parameter_declaration", outline_query)
        self.assertIn("resource_declaration", outline_query)
        self.assertIn("@name", outline_query)
        self.assertIn('"kind"', outline_query)
