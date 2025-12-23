# GitHub Actions Workflows

This directory contains GitHub Actions workflows for CI/CD of VS Code themes.

## Workflows

### `ci.yml` - Continuous Integration

**Triggers:**
- Push to `main`, `master`, or `develop` branches
- Pull requests to `main`, `master`, or `develop` branches

**What it does:**
- Validates theme structure (package.json, themes directory)
- Checks package.json for required fields
- Packages each theme as a .vsix file
- Uploads artifacts for download

**Matrix Strategy:**
- Currently configured for `baseline-theme`
- Add more themes to the matrix as you create them

### `publish.yml` - Publish to Marketplace

**Triggers:**
- GitHub Releases (when a release is published)
- Manual workflow dispatch

**What it does:**
- Packages themes
- Publishes to VS Code Marketplace (if secrets are configured)
- Uploads .vsix artifacts

**Required Secrets:**
- `VSCE_PAT`: Personal Access Token from Azure DevOps with Marketplace (Manage) scope
- `VSCE_PUBLISHER_ID`: (Optional) Your publisher ID (defaults to 'xRiskLab')

**Setup:**
1. Create a Personal Access Token at https://dev.azure.com
2. Add it as `VSCE_PAT` in repository secrets
3. Create a release to trigger automatic publishing

### `package.yml` - Package All Themes

**Triggers:**
- Manual workflow dispatch
- Push of version tags (v*)

**What it does:**
- Automatically finds all themes in the repository
- Packages all themes as .vsix files
- Uploads artifacts

**Use cases:**
- Manual packaging for testing
- Creating release packages before publishing

## Adding New Themes

When you add a new theme:

1. **Update `ci.yml`**: Add the theme name to the matrix strategy
2. **Update `publish.yml`**: Add the theme name to the matrix strategy
3. **No changes needed for `package.yml`**: It automatically discovers themes

Example:
```yaml
strategy:
  matrix:
    theme:
      - baseline-theme
      - your-new-theme  # Add here
```

## Secrets Setup

To enable automatic publishing:

1. Go to your repository → Settings → Secrets and variables → Actions
2. Add the following secrets:
   - `VSCE_PAT`: Your Azure DevOps Personal Access Token
   - `VSCE_PUBLISHER_ID`: (Optional) Your publisher ID

See [PUBLISHING.md](../baseline-theme/PUBLISHING.md) for detailed instructions on creating a PAT.

