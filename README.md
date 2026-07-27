# homebrew-vendor
Homebrew tap for Pointr-customized third-party packages.

## How to use
To install the formulae inside this tap you need to add it via:
```
brew tap pointrlabs/vendor
brew trust pointrlabs/vendor
```

Afterwards you can install formulae like any other homebrew formula:
```
brew install [name of the package]
```

For example:
```
brew install qmaplibre
```

To upgrade a formula:
```
brew update
brew upgrade qmaplibre
```

## Pointr Homebrew helpers (`ptr-brew`)

This tap also hosts the helpers used to access the **private** `pointrlabs/internal`
tap, since this repo is public and can be reached without credentials:

| Path | Purpose |
| --- | --- |
| `bootstrap.sh` | Fetched via `curl` to install or upgrade the `ptr-brew` formula. Deliberately minimal — it is served from an unpinned branch, so logic belongs in `bin/`. |
| `bin/ptr-setup` | Verifies a token, saves credentials to `~/.pointr-brew`, taps and trusts both taps. |
| `bin/ptr-brew` | Wrapper around `brew` that authenticates before each command. |
| `Formula/ptr-brew.rb` | Installs the two scripts into `$(brew --prefix)/bin`. |

End users only run the bootstrap one-liner documented in the
[homebrew-internal README](https://github.com/pointrlabs/homebrew-internal#setup).

### Releasing a new version of the helpers

The helpers are installed by a formula, so changes to `bin/` require a new tag.
The **tag is the only place the version is written**: Homebrew derives the
version from `version/ptr-brew/<x.y.z>`, and `inreplace` stamps it into the
scripts at install time (they ship with `PTR_BREW_VERSION="dev"`, which is what
you see when running them straight from a checkout). Both commands print their
version on startup, so shared logs always identify the build.

1. Merge the changes to `develop`.
2. Tag the commit, e.g. `git tag version/ptr-brew/1.0.3`.
3. Read the commit hash with `git rev-parse version/ptr-brew/1.0.3`.
4. Update `tag:` and `revision:` in `Formula/ptr-brew.rb`, then commit and push
   both the branch and the tag.

Anything in `bin/` must be committed *before* tagging — the tag is what supplies
those files. Only the formula is edited afterwards.

The formula-update commit lands *after* the tag, so the tagged tree does not
contain the formula that references it. That is expected — Homebrew reads the
formula from the tap checkout and only clones the tagged tree for `bin/`.

Users pick up the new version by re-running the bootstrap one-liner, which
upgrades in place. `bootstrap.sh` itself is served from `develop` and is **not**
pinned, so edits to it reach new users immediately without a tag.

There is no `bottle do` block — these are plain shell scripts with nothing to
compile, so the `bottle` workflow does not apply to this formula.

## How to build and upload bottles
There is a `bottle` workflow which you can trigger under "Actions". You need to type in the name of the formula to bottle. The workflow will create the bottles, upload to Packages and then automatically push the bottle definition to the formula in the specified branch.

### How to build bottles manually
```
brew install --build-bottle --verbose pointrlabs/vendor/maplibre-gl-native
brew bottle pointrlabs/vendor/maplibre-gl-native
```

This will output the bottle stub that should be inserted into the formula. It will also produce the tar.gz archive, which you should upload into Releases section of the target repo. A couple more things to be careful about:
- Before uploading, you may need to rename the archive to be like `maplibre-map-renderer-1.1.arm64_sequoia.bottle.tar.gz` (there are sometimes extra dashes, or unnecessary revision numbers, which should be removed).
- You will need to update `root_url` to match the repo you are uploading the bottle to. This root url will contain the git tag as its last part. If your tag contains slashes, those slashes should be represented with `%2F` in the url. An example: `https://github.com/pointrlabs/maplibre-gl-native/releases/download/version%2Fmap-renderer%2F1.1`
