PLUGIN         = plugins/claude-armcknight
MANIFEST       = $(PLUGIN)/.claude-plugin/plugin.json
CHANGELOG      = CHANGELOG.md
# vrsn's --key cannot read JSON, so the version is located by regex instead.
VERSION_PATTERN = "version": "([^"]+)"
VERSION         = $(shell vrsn -r -f $(MANIFEST) -p '$(VERSION_PATTERN)')

.PHONY: validate version patch minor major release release-rc

# What CI runs. Catches manifest errors and, more usefully, command frontmatter
# that fails to parse — which otherwise loads silently with empty metadata.
validate:
	claude plugin validate $(PLUGIN)
	claude plugin validate .

version:
	@echo $(VERSION)

patch minor major:
	vrsn $@ -f $(MANIFEST) -p '$(VERSION_PATTERN)'
	@echo "Bumped to $$(vrsn -r -f $(MANIFEST) -p '$(VERSION_PATTERN)'). Now run: make release"

# Bump first (make patch/minor/major), then release. The bump is the release as
# far as users are concerned: Claude Code tracks main and compares version
# strings, so a tag without a manifest bump moves nobody.
# Bump first (make patch/minor/major), then release. The bump is what users
# actually receive; prepare-release refuses if the manifest still matches the
# last changelog section, which catches forgetting to bump.
#
# The GitHub release is left to CI, which the pushed tag triggers.
release: validate
	prepare-release --file $(MANIFEST) --pattern '$(VERSION_PATTERN)' --changelog $(CHANGELOG) --push

release-rc: validate
	prepare-release rc --file $(MANIFEST) --pattern '$(VERSION_PATTERN)' --changelog $(CHANGELOG) --push
