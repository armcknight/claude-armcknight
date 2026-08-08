---
description: "Review the branch diff against a freshly fetched base branch for missing tests, docs, changelog entries, and orphaned code."
argument-hint: "[base-branch]"
---

- Look at the diff between the current branch and a freshly fetched upstream `main` (or another base branch provided as an argument to this command) and
- Look around for any auxiliary sources that should be updated:
  - tests
  - readmes
  - if it's a user-facing change, add an entry to the appropriate changelog
- Check for any codepaths that were orphaned as part of the changes that should result in dead code cleanup. Use XcodeBuildMCP, xcode-index-mcp and the swiftlens mcp
- Check for obvious issues with the sentry mcp.
