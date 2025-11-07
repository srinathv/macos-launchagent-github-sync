# macOS Launch Agent for Daily GitHub Repository Sync

Automatically download and update GitHub repositories every morning using macOS launch agents.

## What are Launch Agents?

Launch agents are background processes on macOS managed by `launchd`, the system's service management framework. They can:
- Run tasks at specific times or intervals
- Start automatically at login
- Run without user interaction
- Maintain consistent execution even after system restarts

## Overview

This project provides a simple setup to automatically clone or pull GitHub repositories at a scheduled time each morning. Perfect for:
- Keeping local copies of important repositories up-to-date
- Syncing documentation or configuration repos
- Maintaining backups of GitHub projects
- Tracking changes in repositories you monitor

## Project Structure

```
.
├── README.md                           # This file
├── scripts/
│   └── github-sync.sh                  # Main sync script
├── examples/
│   ├── com.github.sync.plist          # Example launch agent plist
│   └── repos.conf                      # Example repository configuration
└── INSTALL.md                          # Installation instructions
```

## How It Works

1. **Launch Agent**: A `.plist` file defines when and how the script runs
2. **Sync Script**: A bash script that reads a configuration file and clones/updates repositories
3. **Configuration**: A simple text file listing the GitHub repositories to sync

## Quick Start

1. Clone this repository
2. Edit `examples/repos.conf` to list your GitHub repositories
3. Customize `examples/com.github.sync.plist` with your paths and schedule
4. Copy the plist to `~/Library/LaunchAgents/`
5. Load the launch agent with `launchctl load`

See [INSTALL.md](INSTALL.md) for detailed instructions.

## Features

- Simple text-based configuration
- Supports both public and private repositories (with SSH keys)
- Logs all sync operations
- Runs automatically at your chosen time
- Minimal system resource usage

## Requirements

- macOS 10.10 or later
- Git installed (`xcode-select --install`)
- SSH keys configured for private repositories (optional)

## Customization

- **Schedule**: Modify the `StartCalendarInterval` in the plist file
- **Repositories**: Edit the configuration file to add/remove repos
- **Download Location**: Change `SYNC_DIR` in the sync script
- **Logging**: Adjust log paths in the plist file

## License

MIT License - feel free to use and modify as needed.
