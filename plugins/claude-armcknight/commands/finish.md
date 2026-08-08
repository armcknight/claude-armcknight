---
description: "Finish a work stream: tear down the worktree, mark the Linear issue Done, and clean up."
argument-hint: "<branch>"
---

This is a command that is run whenever finishing a work stream.

- Run `fish -c "work_fish finish $1"` where the arg will be the branch name that's being finished. (Fish-function version, kept while the `work` Rust binary is being validated side-by-side.)
- Run `direnv exec linctl issue update $issueID --state "Done"` to mark the associated issue as Done based on the branch name
- Run the /claude-armcknight:cleanup command.
