# External tools the claude-armcknight plugin's commands shell out to.
#
#   brew trust dorkitude/linctl     # once, see below
#   brew bundle --file=Brewfile
#
# The trust step is required, not optional. linctl comes from a third-party tap,
# and Homebrew refuses to load formulae from untrusted taps — `brew bundle`
# aborts on the first one and installs nothing at all, including the entries
# below it. Trust the tap once and the bundle runs clean.
#
# None of this is needed to install the plugin itself. Install only what the
# commands you actually use require — see the table in README.md.

tap "dorkitude/linctl"
tap "armcknight/tools"

brew "dorkitude/linctl/linctl" # Linear CLI: /claude-armcknight:start, :pr, :merge, :finish
brew "direnv"                  # supplies the Linear token to every linctl call
brew "gh"                      # /claude-armcknight:pr opens PRs and reads CI status

cask "armcknight/tools/work"   # workr: the `work` binary, worktree and tmux teardown for /claude-armcknight:finish
