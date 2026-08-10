PLUGIN         = plugins/claude-armcknight
MANIFEST       = $(PLUGIN)/.claude-plugin/plugin.json
CHANGELOG      = CHANGELOG.md
# vrsn's --key cannot read JSON, so the version is located by regex instead.
VERSION_PATTERN = "version": "([^"]+)"
VERSION         = $(shell vrsn -r -f $(MANIFEST) -p '$(VERSION_PATTERN)')

.DEFAULT_GOAL = help
.PHONY: help init validate version patch minor major release release-rc

# Targets document themselves with a `## name: description` line above them,
# which is the only thing this prints. Only the first colon separates the two,
# so a description may contain further colons.
## help: list these targets
help:
	@awk '/^## /{ t = substr($$0, 4); c = index(t, ":"); printf "  make %-11s %s\n", substr(t, 1, c - 1), substr(t, c + 2) }' $(MAKEFILE_LIST)

# Both taps are third-party, and Homebrew refuses to load formulae or casks from
# an untrusted tap. `brew bundle` aborts on the first one it meets and installs
# nothing at all, including the entries after it, so trust precedes the bundle.
# Both commands are idempotent.
## init: trust the taps and install the dev toolchain from the Brewfile
init:
	brew trust --tap dorkitude/linctl
	brew trust --tap armcknight/tools
	brew bundle --file=Brewfile

# What CI runs. Catches manifest errors and, more usefully, command frontmatter
# that fails to parse — which otherwise loads silently with empty metadata.
## validate: check the plugin and marketplace manifests
validate:
	claude plugin validate $(PLUGIN)
	claude plugin validate .

## version: print the current plugin version
version:
	@echo $(VERSION)

## patch: bump the version in the manifest (also: minor, major)
patch minor major:
	vrsn $@ -f $(MANIFEST) -p '$(VERSION_PATTERN)'
	@echo "Bumped to $$(vrsn -r -f $(MANIFEST) -p '$(VERSION_PATTERN)'). Now run: make release"

# Bump first (make patch/minor/major), then release. The bump is the release as
# far as users are concerned: Claude Code tracks main and compares version
# strings, so a tag without a manifest bump moves nobody. prepare-release
# refuses when [Unreleased] is empty, which catches releasing nothing.
#
# Needs prepare-release 4.4.0 or later, for --pattern. Earlier versions accept
# only --key, which cannot read JSON: 4.3.0 takes the whole manifest as the
# version string and writes it into the changelog as a section heading before it
# fails. `make init` installs a new enough one.
#
# The GitHub release is left to CI, which the pushed tag triggers.
## release: migrate the changelog, commit, tag and push
release: validate
	prepare-release --file $(MANIFEST) --pattern '$(VERSION_PATTERN)' --changelog $(CHANGELOG) --push

## release-rc: same as release, but cut a release candidate
release-rc: validate
	prepare-release rc --file $(MANIFEST) --pattern '$(VERSION_PATTERN)' --changelog $(CHANGELOG) --push
