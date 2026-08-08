---
description: "Review, commit, open a PR described from the Linear issue, then iterate until CI is green."
argument-hint: "[--autonomous] [--draft]"
---

First: perform /claude-armcknight:review

Then:
- Commit any outstanding work in the working index.
- Open the pull request, supplying the title and description:
    - Use `direnv exec linctl` to grab context from the original issue to write a top-line problem/solution statement in the PR description.
    - Use the [conventional commit](https://www.conventionalcommits.org/en/v1.0.0/) format, scoping to specific components when possible like `fix(AutofixStatusView): <message>` or `feat(seer setup): <message>` for the PR title.
    - The description should summarize the solution strategy and pertinent implementation details.
    - Note the linear issue ID in the description.
    - If `$ARGUMENTS` contains `--autonomous`, use `gh pr create` (no `--web`) so no browser is opened. Otherwise use `gh pr create --web`.
    - If `$ARGUMENTS` contains `--draft`, add `--draft` to the `gh pr create` invocation so the PR is opened in draft state.
- Mark the associated linear issue, if there is one, as "In Review" status using `linctl`.
- After opening the PR, keep an eye on any CI checks and iterate to fix breakages until they're all green.
- Once CI passes, add a comment to the PR with `gh`: `@sentry review` to initiate a Seer review. Wait until the action completes, then check for any comments left by Seer on the PR, and address them in a new commit.
    - Important: If any review comments are left by humans, and not just cursor or sentry, flag them to me for manual handling. Do not reply to humans.
- Do another round of CI iteration until all checks pass.
