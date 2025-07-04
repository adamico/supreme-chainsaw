# Godot CI Workflow

This repository includes a GitHub Actions workflow for automated building and exporting of the Godot project.

## Overview

The workflow (`./github/workflows/godot-ci.yml`) automatically builds the project for multiple platforms when code is pushed to the main branch or when pull requests are created.

## Supported Platforms

- **Linux (x86_64)** - Exported as `supreme-chainsaw.x86_64`
- **Windows** - Exported as `supreme-chainsaw.exe`
- **macOS (Universal)** - Exported as `supreme-chainsaw.zip`
- **Web (HTML5)** - Exported as `index.html` with supporting files

## Workflow Features

### Triggers
- Push to `main` branch
- Pull requests targeting `main` branch

### Build Process
1. **Checkout**: Downloads the repository code with Git LFS support
2. **Setup**: Creates build directory structure
3. **Export**: Uses `firebelley/godot-export@v5.2.0` to export for each platform
4. **Upload**: Stores build artifacts for download

### Artifacts
Each successful build creates downloadable artifacts:
- `linux-build` - Contains the Linux executable
- `windows-build` - Contains the Windows executable  
- `macos-build` - Contains the macOS app bundle
- `web-build` - Contains HTML5 game files

## Customization

### Godot Version
Change the Godot version by modifying the `GODOT_VERSION` environment variable in the workflow file:

```yaml
env:
  GODOT_VERSION: 4.4  # Change this to your desired version
```

### Export Targets
The export targets are defined in `export_presets.cfg`. To modify platforms or settings:

1. Open the project in Godot
2. Go to Project → Export
3. Configure your export presets
4. Save the project (this updates `export_presets.cfg`)

### Custom Export Job
For advanced customization, you can enable the custom export job by setting repository variables:

- `ENABLE_CUSTOM_EXPORT`: Set to `'true'` to enable
- `CUSTOM_EXPORT_TARGETS`: JSON array of export preset names, e.g., `'["Linux/X11", "Windows Desktop"]'`
- `CUSTOM_GODOT_VERSION`: Override Godot version for custom exports

## Build Directory Structure

```
build/
├── linux/
│   └── supreme-chainsaw.x86_64
├── windows/
│   └── supreme-chainsaw.exe
├── macos/
│   └── supreme-chainsaw.zip
└── web/
    ├── index.html
    ├── supreme-chainsaw.js
    ├── supreme-chainsaw.wasm
    └── supreme-chainsaw.pck
```

## Requirements

- Godot 4.4+ project
- Valid `export_presets.cfg` file
- Git LFS (for large assets, if any)

## Troubleshooting

### Export Preset Not Found
If you get an error about export presets not being found:
1. Open your project in Godot
2. Go to Project → Export
3. Add and configure the required export presets
4. Ensure the preset names match those in the workflow file

### Missing Dependencies
If builds fail due to missing dependencies:
1. Check that all required project files are committed
2. Ensure export templates are compatible with your Godot version
3. Verify that export presets are properly configured

## Local Testing

To test exports locally:
1. Open the project in Godot
2. Go to Project → Export
3. Export each preset manually to verify configuration
4. Check that exported files work correctly

## Files Created

- `.github/workflows/godot-ci.yml` - Main workflow file
- `export_presets.cfg` - Export configuration for all platforms
- Updated `.gitignore` - Excludes build artifacts from version control