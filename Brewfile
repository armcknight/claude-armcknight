# External tools the claude-armcknight plugin's commands shell out to.
#
#   brew bundle --file=Brewfile
#
# None of this is needed to install the plugin itself. Install only what the
# commands you actually use require — see the table in README.md.

tap "dorkitude/linctl"
tap "armcknight/tools"

brew "dorkitude/linctl/linctl" # Linear CLI: /claude-armcknight:start, :pr, :merge, :finish
brew "direnv"                  # supplies the Linear token to every linctl call
brew "gh"                      # /claude-armcknight:pr opens PRs and reads CI status
brew "fish"                    # /claude-armcknight:finish shells out through `fish -c`

cask "armcknight/tools/work"   # workr: worktree and tmux teardown for /claude-armcknight:finish
