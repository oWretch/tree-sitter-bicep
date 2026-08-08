# tree-sitter-bicep

[![Build Status](https://github.com/amaanq/tree-sitter-bicep/actions/workflows/ci.yml/badge.svg)](https://github.com/amaanq/tree-sitter-bicep/actions/workflows/ci.yml)
[![Discord](https://img.shields.io/discord/1063097320771698699?logo=discord)](https://discord.gg/w7nTvsVJhm)

A [tree-sitter](https://github.com/tree-sitter/tree-sitter) parser for
[Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview),
the declarative language for deploying Azure resources.

## What is tree-sitter-bicep?

This project provides a production-ready parser and syntax tree for Bicep files,
enabling tools like editors, linters, and language servers to understand and
work with Bicep code programmatically.

## Supported Bicep Features

This grammar supports **all language features up to
[Bicep v0.45.6](https://github.com/Azure/bicep/releases/tag/v0.45.6)** (July
2026), including:

- **Declarations**: `metadata`, `param`, `var`, `resource`, `module`, `output`,
  `type`, `func`
- **Directives**: `#disable-next-line`, `#suppress` (for lint rules)
- **Decorators**: `@description`, `@minLength`, `@maxLength`, `@minValue`,
  `@maxValue`, `@export`, `@secure`, etc.
- **Scopes**: Resource group, subscription, management group, tenant-level
  deployments
- **Data Types**: Primitives (`string`, `int`, `bool`, `array`, `object`),
  secure types (`secureString`, `secureObject`), user-defined types
- **Expressions**: String interpolation, ternary operators, property and array
  access, function calls
- **Resources**: Standard and child resources with symbolic names and API
  versioning
- **Modules**: Bicep file composition with parameter passing
- **User-Defined Functions**: Custom reusable logic with parameters and return
  types
- **Conditions & Loops**: `if`, `for` expressions for conditional and iterative
  deployments

## Known Limitations

These Bicep features are **not yet fully supported** in the grammar:

- **Type inference in some edge cases** — Some complex union types or
  conditionals may require explicit annotation
- **Comments at specific locations** — Comments between decorators and
  declarations may not parse perfectly

## How to Use

See the [tree-sitter documentation](https://tree-sitter.github.io) for language
bindings (JavaScript, Python, Rust, Go, etc.) to integrate this parser into your
tools.

## Contributing

Contributions are welcome! If you find gaps in Bicep feature coverage, please
open an issue or PR.
