# Publishing to VS Code Marketplace

## Prerequisites

1. **Create a Microsoft/Azure account** if you don't have one
2. **Create a publisher account** on the VS Code Marketplace

## Step-by-Step Guide

### 1. Install vsce (Visual Studio Code Extension Manager)

```bash
npm install -g @vscode/vsce
```

### 2. Create a Publisher Account

1. Go to https://marketplace.visualstudio.com/manage
2. Sign in with your Microsoft account
3. Click "Create publisher"
4. Fill in the required information:
   - Publisher ID (this will be your publisher name in package.json)
   - Display name
   - Email

### 3. Get a Personal Access Token (PAT)

1. Go to https://dev.azure.com
2. Click on your profile icon → Security → Personal access tokens
3. Click "New Token"
4. Settings:
   - Name: "VS Code Marketplace"
   - Organization: All accessible organizations
   - Expiration: Custom (set to your preference)
   - Scopes: Click "Show all scopes" → Check "Marketplace" → "Manage"
5. Click "Create" and **copy the token** (you won't see it again!)

### 4. Update package.json

Replace `"publisher": "baseline"` with your actual publisher ID from step 2.

```bash
cd vscode-theme
```

Edit package.json and change the publisher field to your publisher ID.

### 5. Package the Extension

```bash
vsce package
```

This creates a `.vsix` file that you can test locally:

```bash
code --install-extension baseline-theme-1.0.0.vsix
```

### 6. Publish to Marketplace

```bash
vsce publish
```

You'll be prompted for your Personal Access Token from step 3.

Alternatively, you can login first:

```bash
vsce login YOUR_PUBLISHER_ID
```

Then publish:

```bash
vsce publish
```

### 7. Verify Publication

1. Go to https://marketplace.visualstudio.com/manage
2. You should see your extension listed
3. It may take a few minutes to appear in search results

## Updating the Extension

When you want to publish an update:

1. Update the version in package.json (e.g., 1.0.0 → 1.0.1)
2. Update CHANGELOG.md with changes
3. Run:

```bash
vsce publish patch  # for 1.0.0 → 1.0.1
# or
vsce publish minor  # for 1.0.0 → 1.1.0
# or
vsce publish major  # for 1.0.0 → 2.0.0
```

## Testing in Cursor and Kiro

Once published to the VS Code Marketplace:

### Cursor
1. Open Cursor
2. Go to Extensions
3. Search for "Baseline Theme"
4. Install and activate

### Kiro
1. Open Kiro
2. Go to Extensions
3. Search for "Baseline Theme"
4. Install and activate

Both editors are VS Code compatible and can install extensions from the marketplace.

## Troubleshooting

### "Publisher not found"
- Make sure you've created a publisher account at https://marketplace.visualstudio.com/manage
- Update the publisher field in package.json with your actual publisher ID

### "Authentication failed"
- Your PAT may have expired or doesn't have the right permissions
- Create a new PAT with "Marketplace (Manage)" scope

### "Extension validation failed"
- Run `vsce package` to see detailed error messages
- Common issues: missing README, invalid icon format, missing license

## Resources

- [VS Code Publishing Guide](https://code.visualstudio.com/api/working-with-extensions/publishing-extension)
- [vsce Documentation](https://github.com/microsoft/vscode-vsce)
- [Marketplace Management Portal](https://marketplace.visualstudio.com/manage)
