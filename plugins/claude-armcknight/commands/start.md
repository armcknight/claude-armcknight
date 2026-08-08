---
description: "Start the Linear issue for the current branch: fetch it, set it In Progress, and plan the work."
---

If the current branch name corresponds to a linear task:

1. Run `direnv exec linctl issue get` to fetch the full details of the current issue based on the branch name
2. Read the title, description, and any other relevant content from the ticket output
3. Run `direnv exec linctl issue update $issueID --state "In Progress` to update the issue to 'In Progress' state
4. also, make sure it's assigned to me. notify me if it was previously assigned to someone else.
5. Based on the ticket content, create a comprehensive plan using the TodoWrite tool to track all the work needed to complete this issue
6. Do steps 1-3 silently without mentioning them unless there's an error
7. After creating the plan, present it to the user and ask if they'd like to proceed or adjust the plan

If we're not on a branch corresponding to a linear task, like `main`, do nothing.
