# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.1] 2026-08-10

### Added
- `make validate`, `make patch/minor/major`, `make release` and `make release-rc`, plus `ci` and `release` workflows delegating to `armcknight/workflows`. The release job fails if the tag disagrees with the manifest version, since a tag alone moves no installs.
- `Brewfile` covering the tools the commands shell out to, and the `brew trust dorkitude/linctl` step it needs — without which `brew bundle` aborts on the untrusted tap and installs nothing at all.

### Changed
- `finish` tears down the worktree with `work finish` from [workr](https://github.com/armcknight/workr) rather than the fish function it came from.

## [0.1.0] 2026-08-08

### Added
- Initial extraction from a private dotfiles repo, where these commands lived in `configuration/.claude/commands/` and were installed by rsyncing into `$HOME`.
- Seven commands — `start`, `review`, `commit`, `pr`, `merge`, `finish`, `cleanup` — namespaced as `/claude-armcknight:<command>`.
- `description` and `argument-hint` frontmatter on every command. Without it the metadata loads empty at runtime, silently.
- `merge` and `finish` read their branch argument as `$1`. They previously used fish's `$argv[1]`, which Claude Code never substitutes and which reached the model as literal text.
