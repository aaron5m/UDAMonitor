# Installation & Usage

## 1. Clone the repository

First, clone the UDAMonitor repository onto the machine where you want it to run (local machine or EC2):

```
git clone https://github.com/aaron5m/UDAMonitor.git
cd UDAMonitor/monitor
```

The project is designed to be run directly from the cloned repository.

## 2. Configure monitored URLs

Edit the configuration file: **config/urls.txt**

Each line contains: <url> <interval-in-minutes>

Example:
```
https://example.com 5
https://www.microsoft.com 10
```

## 3. Install UDAMonitor

Run the installer script:

```
bin/start_monitor.sh
```

This script acts as an installer and performs the following steps:
- Sets executable permissions on all required scripts
- Verifies runtime directories ( logs/ , tmp/ ) exist and are writable
- Removes any existing UDAMonitor-managed cron jobs
- Creates new cron jobs based on config/urls.txt
    - <url> is checked for http status every <interval-in-minutes>

If config/urls.txt is modified, start_monitor.sh must be re-run to apply changes.

## 4. Runtime behavior

Cron executes bin/run_monitor.sh for each url at the configured intervals

Logs are written to: **logs/particular-website.log**

## 5. Stopping UDAMonitor

To remove all UDAMonitor cron jobs run:

```
bin/stop_monitor.sh
```

This safely removes only cron jobs managed by UDAMonitor.

## 6. Watching UDAMonitor

You can see the five most recent log entries for your websites from the console

```
bin/watch_monitor.sh
```

---

## Why this design

Config-driven behavior (no script edits required)
Idempotent installer (start_monitor.sh can be re-run safely)
Clear separation between install-time and runtime logic
Works consistently across local machines and EC2

