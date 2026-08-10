# Every external dependency of this repo: the tools the plugin's commands shell
# out to at runtime, and the tools that build a release.
#
#   make init
#
# That target trusts the taps and then runs `brew bundle --file=Brewfile`. The
# trust step is required, not optional. Both taps are third-party, and Homebrew
# refuses to load formulae or casks from an untrusted tap — `brew bundle` aborts
# on the first one and installs nothing at all, including the entries below it.
#
# None of this is needed to install the plugin itself. As a plugin user, install
# only what the commands you actually use require — see the table in README.md.

tap "dorkitude/linctl"
tap "armcknight/tools"

brew "dorkitude/linctl/linctl" # Linear CLI: /claude-armcknight:start, :pr, :merge, :finish
brew "direnv"                  # supplies the Linear token to every linctl call
brew "gh"                      # /claude-armcknight:pr opens PRs and reads CI status

cask "armcknight/tools/work"   # workr: the `work` binary, worktree and tmux teardown for /claude-armcknight:finish
cask "armcknight/tools/tools"  # vrsn and prepare-release, for `make patch` and `make release`.
                               # 4.4.0 or later — earlier ones have no --pattern and cannot read the JSON manifest.
