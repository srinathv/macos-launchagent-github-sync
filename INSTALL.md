# Installation Guide

This guide will walk you through setting up the GitHub sync launch agent on your macOS system.

## Prerequisites

1. **Git**: Ensure Git is installed
   ```bash
   git --version
   ```
   If not installed, run:
   ```bash
   xcode-select --install
   ```

2. **SSH Keys** (for private repositories): Generate and add to GitHub
   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   cat ~/.ssh/id_ed25519.pub
   ```
   Then add the public key to your GitHub account at https://github.com/settings/keys

## Installation Steps

### 1. Clone This Repository

```bash
cd ~/Documents
git clone https://github.com/yourusername/macos-launchagent-github-sync.git
```

### 2. Configure Repository List

Edit the configuration file to add your repositories:

```bash
cd macos-launchagent-github-sync
nano examples/repos.conf
```

Add one repository URL per line:
```
https://github.com/username/repository.git
git@github.com:username/private-repo.git
```

Save and exit (Ctrl+X, then Y, then Enter).

### 3. Set Up the Script

Copy the script to a permanent location:

```bash
mkdir -p ~/scripts
cp scripts/github-sync.sh ~/scripts/
cp examples/repos.conf ~/scripts/
chmod +x ~/scripts/github-sync.sh
```

### 4. Test the Script

Run the script manually to ensure it works:

```bash
~/scripts/github-sync.sh
```

Check that repositories are being cloned to `~/GitHubSync/`

### 5. Customize the Launch Agent

Copy the example plist and edit it:

```bash
cp examples/com.github.sync.plist ~/Library/LaunchAgents/
```

Edit the plist file to replace `YOUR_USERNAME` with your actual username:

```bash
nano ~/Library/LaunchAgents/com.github.sync.plist
```

Replace all instances of `YOUR_USERNAME` with your actual username. For example:
- `/Users/YOUR_USERNAME/` becomes `/Users/john/`

Also customize the schedule if desired (see Customization section below).

### 6. Load the Launch Agent

Load the launch agent to start it:

```bash
launchctl load ~/Library/LaunchAgents/com.github.sync.plist
```

Verify it's loaded:

```bash
launchctl list | grep com.github.sync
```

## Customization

### Change the Schedule

Edit `~/Library/LaunchAgents/com.github.sync.plist` and modify the `StartCalendarInterval` section:

**Run at 7:30 AM daily:**
```xml
<key>StartCalendarInterval</key>
<dict>
    <key>Hour</key>
    <integer>7</integer>
    <key>Minute</key>
    <integer>30</integer>
</dict>
```

**Run every Monday at 6:00 AM:**
```xml
<key>StartCalendarInterval</key>
<dict>
    <key>Weekday</key>
    <integer>1</integer>
    <key>Hour</key>
    <integer>6</integer>
    <key>Minute</key>
    <integer>0</integer>
</dict>
```

**Run multiple times (e.g., 6 AM and 6 PM):**
```xml
<key>StartCalendarInterval</key>
<array>
    <dict>
        <key>Hour</key>
        <integer>6</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <dict>
        <key>Hour</key>
        <integer>18</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
</array>
```

After making changes, reload the agent:
```bash
launchctl unload ~/Library/LaunchAgents/com.github.sync.plist
launchctl load ~/Library/LaunchAgents/com.github.sync.plist
```

### Change the Download Directory

Edit `~/scripts/github-sync.sh` and modify the `SYNC_DIR` variable:

```bash
SYNC_DIR="${HOME}/MyGitRepos"  # Change to your preferred location
```

## Monitoring

### View Logs

Check the standard output log:
```bash
tail -f ~/Library/Logs/github-sync.log
```

Check the error log:
```bash
tail -f ~/Library/Logs/github-sync-error.log
```

### Manual Trigger

To test or run manually:
```bash
~/scripts/github-sync.sh
```

Or trigger via launchctl:
```bash
launchctl start com.github.sync
```

## Troubleshooting

### Agent Not Running

Check if it's loaded:
```bash
launchctl list | grep com.github.sync
```

If not loaded, try loading it again:
```bash
launchctl load ~/Library/LaunchAgents/com.github.sync.plist
```

### Check for Errors

View system logs:
```bash
log show --predicate 'process == "launchd"' --last 1h | grep github
```

### Permission Issues

Ensure the script is executable:
```bash
chmod +x ~/scripts/github-sync.sh
```

### Git Authentication Issues

For private repos, ensure SSH keys are set up:
```bash
ssh -T git@github.com
```

You should see: "Hi username! You've successfully authenticated..."

## Uninstallation

To remove the launch agent:

```bash
launchctl unload ~/Library/LaunchAgents/com.github.sync.plist
rm ~/Library/LaunchAgents/com.github.sync.plist
rm -rf ~/scripts/github-sync.sh
rm -rf ~/scripts/repos.conf
```

## Common Use Cases

### Backup Important Projects
Keep local backups of critical repositories for offline access.

### Sync Documentation
Automatically update local copies of documentation repos.

### Monitor Changes
Review what changed in tracked repositories each morning.

### Development Environment
Keep development repos up-to-date across multiple machines.

## Security Notes

- Launch agents run in user context (not as root)
- SSH keys should be password-protected
- Consider using GitHub's Fine-grained Personal Access Tokens for HTTPS
- Logs may contain repository names and paths
- The script does not push changes, only pulls/clones

## Additional Resources

- [launchd man page](https://ss64.com/osx/launchd.html)
- [launchctl man page](https://ss64.com/osx/launchctl.html)
- [GitHub SSH Documentation](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
