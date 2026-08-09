PLUGIN         = plugins/claude-armcknight
MANIFEST       = $(PLUGIN)/.claude-plugin/plugin.json
CHANGELOG      = CHANGELOG.md
# vrsn's --key cannot read JSON, so the version is located by regex instead.
VERSION_PATTERN = "version": "([^"]+)"
VERSION         = $(shell vrsn -r -f $(MANIFEST) -p '$(VERSION_PATTERN)')

.PHONY: validate version patch minor major release

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
# This is spelled out rather than delegated to armcknight/tools' prepare-release,
# which would do all of it in one call. prepare-release locates the version with
# --file/--key, and --key cannot read JSON — only vrsn grew a --pattern escape
# hatch. Teach prepare-release --pattern and this target collapses to:
#   prepare-release --file $(MANIFEST) --pattern '$(VERSION_PATTERN)' --push --github-release
# RC releases are blocked on the same gap, so there is no release-rc target yet.
release: validate
	migrate-changelog $(CHANGELOG) $(VERSION)
	git add $(MANIFEST) $(CHANGELOG)
	git commit -m "release $(VERSION)"
	git tag -a $(VERSION) -m "$(VERSION)"
	git push && git push --tags
