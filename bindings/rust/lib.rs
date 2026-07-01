//! This crate provides Bicep and Bicep parameter language support for the [tree-sitter][] parsing library.
//!
//! Typically, you will use the [LANGUAGE_BICEP] constant to add this language to a
//! tree-sitter [Parser][], and then use the parser to parse some code:
//!
//! ```
//! let code = r#"
//! param myParam string = 'Hello, world!'
//! "#;
//! let mut parser = tree_sitter::Parser::new();
//! let language = tree_sitter_bicep::LANGUAGE_BICEP;
//! parser
//!     .set_language(&language.into())
//!     .expect("Error loading Bicep parser");
//! let tree = parser.parse(code, None).unwrap();
//! assert!(!tree.root_node().has_error());
//! ```
//!
//! [Parser]: https://docs.rs/tree-sitter/*/tree_sitter/struct.Parser.html
//! [tree-sitter]: https://tree-sitter.github.io/

use tree_sitter_language::LanguageFn;

extern "C" {
    fn tree_sitter_bicep() -> *const ();
    fn tree_sitter_bicep_params() -> *const ();
}

/// The tree-sitter [`LanguageFn`] for Bicep.
///
/// [LanguageFn]: https://docs.rs/tree-sitter-language/*/tree_sitter_language/struct.LanguageFn.html
pub const LANGUAGE_BICEP: LanguageFn = unsafe { LanguageFn::from_raw(tree_sitter_bicep) };

/// The tree-sitter [`LanguageFn`] for Bicep Params.
///
/// [LanguageFn]: https://docs.rs/tree-sitter-language/*/tree_sitter_language/struct.LanguageFn.html
pub const LANGUAGE_BICEP_PARAMS: LanguageFn =
    unsafe { LanguageFn::from_raw(tree_sitter_bicep_params) };

/// The content of the [`node-types.json`][] file for Bicep.
pub const BICEP_NODE_TYPES: &str = include_str!("../../bicep/src/node-types.json");

/// The content of the [`node-types.json`][] file for Bicep Params.
pub const BICEP_PARAMS_NODE_TYPES: &str = include_str!("../../bicep_params/src/node-types.json");

/// The syntax highlighting query for Bicep.
pub const HIGHLIGHTS_QUERY: &str = include_str!("../../bicep/queries/highlights.scm");

/// The injection query for Bicep.
pub const INJECTIONS_QUERY: &str = include_str!("../../bicep/queries/injections.scm");

/// The local-variable syntax highlighting query for Bicep.
pub const LOCALS_QUERY: &str = include_str!("../../bicep/queries/locals.scm");

#[cfg(test)]
mod tests {
    #[test]
    fn test_can_load_bicep_grammar() {
        let mut parser = tree_sitter::Parser::new();
        parser
            .set_language(&super::LANGUAGE_BICEP.into())
            .expect("Error loading Bicep parser");
    }

    #[test]
    fn test_can_load_bicep_params_grammar() {
        let mut parser = tree_sitter::Parser::new();
        parser
            .set_language(&super::LANGUAGE_BICEP_PARAMS.into())
            .expect("Error loading Bicep Params parser");
    }
}
