---
description: "Squash-merge a branch into main with a generated conventional commit message, then review and clean up."
argument-hint: "<branch>"
---

- If there are any changes in the working index, stash them.
- Look at the diff between the branch `$1` and `main` and write a summary of all the changes to be used as the commit message for a merge commit. Use the [conventional commit](https://www.conventionalcommits.org/en/v1.0.0/) format, scoping to specific components when possible like `fix(AutofixStatusView): <message>` or `feat(seer setup): <message>`.
- Checkout `main` and merge the branch `$1` in, using that message for the merge commit. Use the `--squash` option to make a single commit on `main`. Resolve any merge conflicts and roll them into the commit.
- Run the /claude-armcknight:review command and commit any results.
- Run `direnv exec linctl issue update $issueID --state "In Review"` to mark the associated Linear issue as "In Review".
- Update any relevant README.md files that document code that changed, add new README.md about new (sub)systems that might have been created, and remove README explainers on any removed logic.
- If we had to stash working changes at the beginning, then pop that stash.
- Run the /claude-armcknight:cleanup command.
