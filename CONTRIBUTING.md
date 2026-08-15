# Contributing

## Commit Messages

Use Conventional Commits for every commit and pull request title. The
`Conventional Commits` check validates both before a pull request can merge.

Use `feat`, `fix`, or `perf` for user-facing changes that should trigger a
minor or patch release. Add `!` to the type or a `BREAKING CHANGE:` footer for
a major release. Other accepted types are `build`, `chore`, `ci`, `docs`,
`refactor`, `revert`, `style`, and `test`; they do not create releases.

## Generated Parser Sources

Commit regenerated parser files with grammar changes. Parser CI verifies that
`src/parser.c`, `src/grammar.json`, `src/node-types.json`, and parser headers are
up to date. It is the only workflow that chooses the Tree-sitter ABI.

## Release Process

Maintainers should follow [the release process](docs/releasing.md). Releases are
created automatically from merges to `master`; do not create release tags or
GitHub releases manually.
