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

### 2. Update the Version

1. Checkout and pull the latest `main` branch:
   ```bash
   git checkout main
   git pull origin main
   ```

2. Update the version in `lib/danger-pr-comment/version.rb`:
   ```ruby
   module DangerPrComment
     VERSION = '0.2.0'  # Update this to your new version
   end
   ```

3. Commit the version change:
   ```bash
   git add lib/danger-pr-comment/version.rb
   git commit -m "Release v0.2.0"
   git push origin main
   ```

### 3. Trigger the Release Workflow

1. Go to the [Actions tab](https://github.com/numbata/danger-pr-comment/actions/workflows/release.yml) in GitHub
2. Click "Run workflow"
3. Select the `main` branch
4. Click "Run workflow" (no inputs needed)

### 4. What the Workflow Does

The release workflow will automatically:

1. Read the current version from `lib/danger-pr-comment/version.rb`
2. Create a git tag (e.g., `v0.2.0`)
3. Build the gem
4. Push the gem to RubyGems.org
5. Push the tag to GitHub
6. Create a GitHub Release with auto-generated release notes
7. **Auto-increment** the patch version for next development (e.g., `0.2.0` → `0.2.1`)
8. Commit and push the incremented version to `main`

### 5. Verify the Release

After the workflow completes:

1. Check that the new version appears on [RubyGems.org](https://rubygems.org/gems/danger-pr-comment)
2. Check that the GitHub Release was created: https://github.com/numbata/danger-pr-comment/releases
3. Verify the tag was pushed: https://github.com/numbata/danger-pr-comment/tags
4. Verify the version was auto-incremented in `main`:
   ```bash
   git pull origin main
   cat lib/danger-pr-comment/version.rb
   ```
5. Test installing the new version:
   ```bash
   gem install danger-pr-comment
   ```

## Version Increment Behavior

After a successful release, the workflow automatically increments the **patch** version:
- Release `0.1.0` → Next dev version becomes `0.1.1`
- Release `0.2.0` → Next dev version becomes `0.2.1`
- Release `1.0.0` → Next dev version becomes `1.0.1`

**For MAJOR or MINOR version bumps:**
If you want to release a major or minor version (not a patch), you'll need to manually update the version again after the automatic patch increment:

1. Wait for the release workflow to complete
2. Pull the auto-incremented version: `git pull origin main`
3. Manually set the desired version in `version.rb` (e.g., `0.3.0` or `1.0.0`)
4. Commit and push: `git commit -am "Prepare v0.3.0" && git push origin main`
5. Run the release workflow again

## Manual Release (Not Recommended)

If you need to release manually for any reason:

1. Update the version in `lib/danger-pr-comment/version.rb`
2. Commit and tag:
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
6. Manually increment the version for next development

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
1. Increment to a new version number in `version.rb`
2. Commit and push the change
3. Run the release workflow again

### Auto-increment overwrites desired version

If the workflow auto-increments to a patch version but you wanted a minor/major bump:
1. Wait for the workflow to complete
2. Pull the changes: `git pull origin main`
3. Update `version.rb` to your desired version
4. Commit and push
5. Run the release workflow again
