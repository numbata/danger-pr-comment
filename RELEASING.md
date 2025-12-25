# Releasing

This document describes the process for releasing a new version of the `danger-pr-comment` gem.

## Prerequisites

1. Ensure you have maintainer access to the repository
2. Ensure the `RUBYGEMS_API_KEY` secret is configured in GitHub repository settings
   - Go to Settings → Secrets and variables → Actions
   - Add a secret named `RUBYGEMS_API_KEY` with your RubyGems API key
   - Get your API key from https://rubygems.org/profile/edit

## Release Process

### 1. Prepare the Release

1. Ensure all changes for the release are merged to `main`
2. Ensure all tests pass on `main`
3. Review the changes since the last release:
   ```bash
   git log v0.1.0..HEAD --oneline
   ```
4. Decide on the new version number following [Semantic Versioning](https://semver.org/):
   - **MAJOR** version for incompatible API changes
   - **MINOR** version for new functionality in a backward compatible manner
   - **PATCH** version for backward compatible bug fixes

### 2. Trigger the Release Workflow

1. Go to the [Actions tab](https://github.com/numbata/danger-pr-comment/actions/workflows/release.yml) in GitHub
2. Click "Run workflow"
3. Select the `main` branch
4. Enter the new version number (e.g., `0.2.0`) - **without** the `v` prefix
5. Click "Run workflow"

### 3. What the Workflow Does

The release workflow will automatically:

1. Update the version in `lib/danger-pr-comment/version.rb`
2. Commit the version change
3. Create a git tag (e.g., `v0.2.0`)
4. Build the gem
5. Push the gem to RubyGems.org
6. Push the commit and tag to GitHub
7. Create a GitHub Release with auto-generated release notes

### 4. Verify the Release

After the workflow completes:

1. Check that the new version appears on [RubyGems.org](https://rubygems.org/gems/danger-pr-comment)
2. Check that the GitHub Release was created: https://github.com/numbata/danger-pr-comment/releases
3. Verify the tag was pushed: https://github.com/numbata/danger-pr-comment/tags
4. Test installing the new version:
   ```bash
   gem install danger-pr-comment
   ```

## Manual Release (Not Recommended)

If you need to release manually for any reason:

1. Update the version in `lib/danger-pr-comment/version.rb`
2. Commit the change:
   ```bash
   git add lib/danger-pr-comment/version.rb
   git commit -m "Release v0.2.0"
   git tag v0.2.0
   ```
3. Build and push the gem:
   ```bash
   gem build danger-pr-comment.gemspec
   gem push danger-pr-comment-0.2.0.gem
   ```
4. Push to GitHub:
   ```bash
   git push origin main
   git push origin v0.2.0
   ```
5. Create a GitHub Release manually from the tag

## Troubleshooting

### Workflow fails to push to RubyGems

- Verify the `RUBYGEMS_API_KEY` secret is correctly set
- Check that the API key has permission to push gems
- Ensure the gem name is not already taken by another version

### Workflow fails to create GitHub Release

- Check that the GitHub Actions bot has write permissions
- Verify the tag doesn't already exist
- Check the repository permissions in Settings → Actions → General

### Version conflict

If the version already exists on RubyGems, you cannot overwrite it. You must:
1. Delete the failed release artifacts
2. Increment to a new version number
3. Run the release workflow again
