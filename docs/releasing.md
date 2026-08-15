# Release Process

This document is for maintainers. Releases are fully automated: a qualifying
Conventional Commit merged to `master` creates a versioned GitHub release, then
publishes the matching packages.

## Triggering a Release

[`release.yml`](../.github/workflows/release.yml) runs on pushes to `master`.
Semantic-release examines commits since the last `vX.Y.Z` tag:

| Commit | Release |
| --- | --- |
| `feat:` | Minor |
| `fix:` or `perf:` | Patch |
| `!` or `BREAKING CHANGE:` | Major |
| Other accepted Conventional Commit types | No release |

The pull request workflow validates every commit and the pull request title.
This keeps the merge result suitable for semantic-release regardless of merge
strategy.

## Release Workflow

The workflow runs `npm run release`, which is an alias for the pinned local
`semantic-release` executable. Using the package script is equivalent to
`npx semantic-release`, but guarantees the workflow and local maintainers use
the version recorded in `package-lock.json`.

Semantic-release uses [`.releaserc.json`](../.releaserc.json) to:

1. Calculate the next version and generate release notes.
2. Update `CHANGELOG.md`.
3. Run [`semantic-release-verified-commit.cjs`](../.github/semantic-release-verified-commit.cjs).
4. Create the `vX.Y.Z` tag and GitHub release, including release assets.

## Verified Release Commit

The custom semantic-release plugin is required because the repository creates a
release commit before tagging it. In its `prepare` lifecycle it:

1. Runs [`set-release-version.mjs`](../scripts/set-release-version.mjs) to keep
   `package.json`, `Cargo.toml`, `pyproject.toml`, and `tree-sitter.json` on the
   same version.
2. Runs [`build-release-assets.mjs`](../scripts/build-release-assets.mjs) to
   build the WebAssembly parser and source archive from committed parser sources.
3. Calls the pinned `oWretch/create-verified-commits` action with a GitHub App
   installation token. GitHub creates and signs the commit, so it appears as
   Verified and is attributed to the App.
4. Fetches and resets to the App-created commit. Semantic-release therefore
   creates the release tag on the commit containing the version metadata and
   changelog.

A regular `@semantic-release/git` step would push with Git. This repository uses
the custom plugin to require a Verified GitHub App release commit and to ensure
that the App-created tag can trigger downstream workflows. Do not replace it
with `@semantic-release/git` unless those requirements change.

## Publishing Packages

Pushing `vX.Y.Z` starts [`publish.yml`](../.github/workflows/publish.yml). It
uses pinned Tree-sitter reusable workflows to publish npm, crates.io, and PyPI.
Those jobs consume the generated parser sources committed to the release tag;
they do not regenerate a parser or select an ABI.

Parser CI is the sole ABI authority. A grammar change must commit its generated
parser files, and parser CI verifies them before release. This prevents a newer
release runner or upstream workflow default from changing the parser ABI during
package publication.

Go modules and Swift packages use the root `vX.Y.Z` Git tag directly. They do
not need a registry publishing job or a separate version field in `go.mod` or
`Package.swift`.

## Required Configuration

Configure these repository secrets:

| Secret | Purpose |
| --- | --- |
| `NPM_TOKEN` | Publish npm package |
| `CARGO_REGISTRY_TOKEN` | Publish crates.io package |
| `PYPI_API_TOKEN` | Publish PyPI package |
| `RELEASE_APP_ID` | GitHub App identifier |
| `RELEASE_APP_PRIVATE_KEY` | GitHub App private key |

The GitHub App needs repository contents write permission. Its short-lived
installation token creates the release commit and tag. A workflow's
`GITHUB_TOKEN` should not be used for this: pushes made with it do not trigger
other `push` workflows.

Protect `master` with the parser, query, lint, and `Conventional Commits` checks.
Do not create release tags or GitHub releases manually.

## Validation

Before changing release automation, run:

```sh
npm ci --ignore-scripts --legacy-peer-deps
npx commitlint --from master --to HEAD
npx semantic-release --dry-run --no-ci
actionlint .github/workflows/publish.yml .github/workflows/lint.yml .github/workflows/release.yml
```

A semantic-release dry run from a feature branch loads the full configuration
but deliberately does not publish. Test actual registry publication only through
a controlled release after all required secrets and GitHub App permissions are
configured.
