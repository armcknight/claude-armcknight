# claude-armcknight

[Claude Code](https://claude.com/claude-code) plugins by Andrew McKnight, distributed as a plugin marketplace.

## Install

```
/plugin marketplace add armcknight/claude-armcknight
/plugin install claude-armcknight@armcknight
```

To work on the plugins locally, add this checkout as a directory marketplace instead:

```
/plugin marketplace add /path/to/claude-armcknight
```

## Plugins

### `claude-armcknight`

An issue-to-merge workflow. Each command is one step of the loop this repository's author runs on every ticket: pick up a Linear issue, do the work, review it, commit, open a PR, watch CI, merge, and clean up after the worktree.

| Command | What it does |
| --- | --- |
| `/claude-armcknight:start` | Read the Linear issue matching the current branch, move it to In Progress, check assignment, and write a plan. Does nothing on `main`. |
| `/claude-armcknight:review` | Diff the branch against a freshly fetched base branch. Look for tests, READMEs and changelog entries that need updating, and for code orphaned by the change. |
| `/claude-armcknight:commit` | Run `/claude-armcknight:review`, then stage and commit in [conventional commit](https://www.conventionalcommits.org/en/v1.0.0/) format. |
| `/claude-armcknight:pr` | Run `/claude-armcknight:review`, commit outstanding work, open a PR titled and described from the Linear issue, then iterate until CI is green and review comments are addressed. Accepts `--autonomous` and `--draft`. |
| `/claude-armcknight:merge` | Squash-merge a branch into `main` with a generated conventional-commit message, review the result, update the issue, and refresh affected READMEs. |
| `/claude-armcknight:finish` | Close out a work stream: tear down the worktree, mark the Linear issue Done, and run `/claude-armcknight:cleanup`. |
| `/claude-armcknight:cleanup` | Remove the Xcode DerivedData directory belonging to a worktree. |

Commands are namespaced by plugin, so `/pr` becomes `/claude-armcknight:pr`. The commands call each other by the namespaced name.

## Requirements

These commands shell out to tools that are not bundled here. Install what the commands you use need, or take the lot:

```sh
brew trust dorkitude/linctl     # required, see below
brew bundle --file=Brewfile
```

`linctl` comes from a third-party tap. Homebrew refuses to load formulae from untrusted taps, and `brew bundle` aborts on the first one it meets — installing **nothing**, not even the entries after it. Trust the tap once and the bundle runs clean.

| Tool | Used by | Purpose |
| --- | --- | --- |
| [`linctl`](https://github.com/dorkitude/linctl) | `start`, `pr`, `merge`, `finish` | Read and update Linear issues from the CLI. |
| `direnv` | `start`, `pr`, `merge`, `finish` | Every `linctl` call runs under `direnv exec`, which supplies the Linear API token from the repository's `.envrc`. |
| [`gh`](https://cli.github.com) | `pr` | Open PRs and read CI status. |
| [`workr`](https://github.com/armcknight/workr) | `finish` | Supplies the `work` binary. `finish` runs `work finish <branch>` to tear down the git worktree and its tmux session. |

## Assumptions

These commands were written for one person's setup and published as a reference. Read them before you install them — they are short, and they are opinionated in ways that will not suit every project.

- **Branch names encode a Linear issue.** `/claude-armcknight:start` derives the issue ID from the current branch and does nothing if it cannot.
- **`/claude-armcknight:pr` is Sentry-specific in one step.** After CI passes it comments `@sentry review` to trigger a Seer review, then addresses Seer's comments. On a non-Sentry repository, delete that step.
- **`/claude-armcknight:review` names specific MCP servers** — XcodeBuildMCP, xcode-index-mcp, swiftlens and Sentry. Without them, those checks are skipped.
- **`/claude-armcknight:cleanup` is Xcode-only.** It removes a DerivedData directory and does nothing useful for a non-Xcode project.
- **`/claude-armcknight:start` checks that the issue is assigned to you** and reports if it was previously assigned to somebody else.
- **`/claude-armcknight:merge` and `/claude-armcknight:finish` take the branch name as their first argument** — `/claude-armcknight:merge my-branch`. They do not infer it from the current checkout.

## Arguments

Commands read their arguments through the placeholders Claude Code substitutes before the command runs:

| Placeholder | Expands to |
| --- | --- |
| `$1`, `$2`, … | The first, second, … whitespace-separated argument. Used by `merge` and `finish` for the branch name. |
| `$ARGUMENTS` | Everything passed, as one string. Used by `pr` to test for `--autonomous` and `--draft`. |

Declare them in the command's frontmatter with `argument-hint`, which is what the user sees when picking the command.

## Used by

[superlinear](https://github.com/armcknight/superlinear) drives `/claude-armcknight:start`, `/claude-armcknight:commit` and `/claude-armcknight:pr --autonomous` to take a Linear issue to an open pull request without a human in the loop.

## Releasing

```sh
make patch       # or minor / major — bumps version in plugin.json
make release     # migrates the changelog, commits, tags, pushes
```

Pushing the tag triggers the release workflow, which revalidates the manifests and creates the GitHub release with notes from the changelog. `make release-rc` cuts a release candidate instead.

**The version bump is the release.** Claude Code installs this plugin by cloning the repo and tracking `main` — the clone fetches `+refs/heads/main:refs/remotes/origin/main`, so tags never reach anyone's machine. `claude plugin update` compares the `version` in `plugin.json` on `main`, so a tag without a bump moves nobody. The release job fails when the tag and the manifest disagree, for exactly that reason.

## License

Apache License 2.0. See [LICENSE](LICENSE).
