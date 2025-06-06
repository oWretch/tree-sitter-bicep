# tree-sitter-bicep

[![Build Status](https://github.com/amaanq/tree-sitter-bicep/actions/workflows/ci.yml/badge.svg)](https://github.com/amaanq/tree-sitter-bicep/actions/workflows/ci.yml)
[![Discord](https://img.shields.io/discord/1063097320771698699?logo=discord)](https://discord.gg/w7nTvsVJhm)

Bicep grammar for [tree-sitter](https://github.com/tree-sitter/tree-sitter).

Adapted from [the official spec](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview)

## Features

### Outline Support

This grammar includes support for generating an outline of Bicep files. The outline feature analyzes the syntax tree and produces a hierarchical summary of the main constructs:

- **Parameters** (`param`) - Input parameters with their types and default values
- **Variables** (`var`) - Variable declarations and assignments  
- **Resources** (`resource`) - Azure resource definitions
- **Modules** (`module`) - Module references and instantiations
- **Outputs** (`output`) - Output declarations with types and values
- **Types** (`type`) - Custom type definitions
- **Functions** (`func`) - User-defined functions
- **Metadata** (`metadata`) - Metadata declarations
- **Tests** (`test`) - Test block definitions
- **Asserts** (`assert`) - Assertion statements

The outline information is extracted using tree-sitter queries in `queries/outline.scm` and can be used by editor integrations to provide symbol navigation and outline views.

#### Usage

The outline query is available in the Rust bindings as `OUTLINE_QUERY`:

```rust
use tree_sitter_bicep::OUTLINE_QUERY;

// Use with tree-sitter query API to extract outline information
let query = Query::new(&language, OUTLINE_QUERY)?;
// ... execute query on parsed tree
```
