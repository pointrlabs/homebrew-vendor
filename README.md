# homebrew-vendor
Homebrew tap for Pointr-customized third-party packages.

## How to use
To install the formulae inside this tap you need to add it via:
```
brew tap pointrlabs/vendor
```

Afterwards you can install formulae like any other homebrew formula:
```
brew install [name of the package]
```

For example:
```
brew install maplibre-gl-native
brew install maplibre-map-renderer
```

To upgrade a formula:
```
brew update
brew upgrade pointrlabs/vendor/maplibre-gl-native
```

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
