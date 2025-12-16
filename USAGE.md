# Usage Guide

## Quick Reference

### Installation
```bash
./install.sh
```

### Testing Scripts Manually
```bash
# Test GitHub sync
./scripts/github-sync.sh

# Test Homebrew update
./scripts/brew-update.sh

# Test email launcher
./scripts/email-app-launcher.sh
```

### View Logs
```bash
# GitHub sync logs
tail -f ~/Library/Logs/github-sync.log

# Brew update logs
tail -f ~/Library/Logs/brew-update.log

# Email launcher logs
tail -f ~/Library/Logs/email-launcher.log
```

### Managing Launch Agents

#### Check Status
```bash
launchctl list | grep com.github.sync
launchctl list | grep com.brew.update
launchctl list | grep com.email.launcher
```

#### Stop a Service
```bash
launchctl unload ~/Library/LaunchAgents/com.github.sync.plist
launchctl unload ~/Library/LaunchAgents/com.brew.update.plist
launchctl unload ~/Library/LaunchAgents/com.email.launcher.plist
```

#### Start a Service
```bash
launchctl load ~/Library/LaunchAgents/com.github.sync.plist
launchctl load ~/Library/LaunchAgents/com.brew.update.plist
launchctl load ~/Library/LaunchAgents/com.email.launcher.plist
```

#### Restart a Service (after changes)
```bash
launchctl unload ~/Library/LaunchAgents/com.github.sync.plist
launchctl load ~/Library/LaunchAgents/com.github.sync.plist
```

### Uninstallation
```bash
./uninstall.sh
```

## Customization Guide

### 1. GitHub Sync

**Configure repositories:**
Edit `examples/repos.conf`:
```bash
https://github.com/username/repo1.git
git@github.com:username/repo2.git
https://github.com/organization/repo3.git
```

**Change schedule:**
Edit `examples/com.github.sync.plist`:
```xml
<key>StartCalendarInterval</key>
<dict>
    <key>Hour</key>
    <integer>6</integer>    <!-- Hour (0-23) -->
    <key>Minute</key>
    <integer>0</integer>     <!-- Minute (0-59) -->
</dict>
```

**Change sync directory:**
Edit `scripts/github-sync.sh`:
```bash
SYNC_DIR="${HOME}/GitHubSync"  # Change this path
```

### 2. Brew Update

**Change schedule:**
Edit `examples/com.brew.update.plist`:
```xml
<key>StartCalendarInterval</key>
<dict>
    <key>Hour</key>
    <integer>7</integer>    <!-- Hour (0-23) -->
    <key>Minute</key>
    <integer>0</integer>     <!-- Minute (0-59) -->
</dict>
```

**Run multiple times per day:**
Replace `StartCalendarInterval` with an array:
```xml
<key>StartCalendarInterval</key>
<array>
    <dict>
        <key>Hour</key>
        <integer>7</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <dict>
        <key>Hour</key>
        <integer>19</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
</array>
```

### 3. Email Launcher

**Change email apps:**
Edit `scripts/email-app-launcher.sh`:
```bash
EMAIL_APPS=("Proton Mail" "Microsoft Outlook")
# Change to your preferred apps, e.g.:
# EMAIL_APPS=("Mail" "Spark")
```

**Change launch frequency:**
Edit `examples/com.email.launcher.plist`:
```xml
<key>StartInterval</key>
<integer>3600</integer>  <!-- Seconds between runs -->
```

Common intervals:
- Every 30 minutes: `1800`
- Every hour: `3600`
- Every 2 hours: `7200`
- Every 4 hours: `14400`

**Disable auto-launch at login:**
Edit `examples/com.email.launcher.plist`:
```xml
<key>RunAtLoad</key>
<false/>  <!-- Change to false -->
```

## Schedule Examples

### Run only on weekdays
```xml
<key>StartCalendarInterval</key>
<dict>
    <key>Weekday</key>
    <integer>1</integer>  <!-- Monday=1, Sunday=0 -->
    <key>Hour</key>
    <integer>9</integer>
    <key>Minute</key>
    <integer>0</integer>
</dict>
```

### Run on specific days of the month
```xml
<key>StartCalendarInterval</key>
<dict>
    <key>Day</key>
    <integer>1</integer>  <!-- First day of month -->
    <key>Hour</key>
    <integer>10</integer>
    <key>Minute</key>
    <integer>0</integer>
</dict>
```

### Run every N seconds (simpler than calendar)
```xml
<key>StartInterval</key>
<integer>300</integer>  <!-- Every 5 minutes -->
```

## Troubleshooting

### Scripts not running?

1. Check if the agent is loaded:
   ```bash
   launchctl list | grep com.github.sync
   ```

2. Check the error log:
   ```bash
   cat ~/Library/Logs/github-sync-error.log
   ```

3. Verify script permissions:
   ```bash
   ls -la scripts/
   # Should show -rwxr-xr-x (executable)
   ```

4. Test the script manually:
   ```bash
   ./scripts/github-sync.sh
   ```

### Email apps not launching?

1. Check app names are exact:
   ```bash
   ls /Applications/ | grep -i mail
   ls /Applications/ | grep -i outlook
   ```

2. App names must match exactly (case-sensitive):
   - "Proton Mail.app" → use "Proton Mail"
   - "Microsoft Outlook.app" → use "Microsoft Outlook"

### Brew update fails?

1. Check Homebrew installation:
   ```bash
   which brew
   ```

2. Verify PATH in plist includes Homebrew location:
   - Intel Mac: `/usr/local/bin`
   - Apple Silicon: `/opt/homebrew/bin`

## Advanced: Running Scripts on Multiple Schedules

Create multiple plist files for different schedules:

```bash
cp examples/com.github.sync.plist examples/com.github.sync.morning.plist
cp examples/com.github.sync.plist examples/com.github.sync.evening.plist
```

Edit each with different times, then load both:
```bash
launchctl load ~/Library/LaunchAgents/com.github.sync.morning.plist
launchctl load ~/Library/LaunchAgents/com.github.sync.evening.plist
```

Remember to change the Label in each plist to be unique!
