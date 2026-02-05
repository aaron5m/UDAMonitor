## v1.6 - 2026-02-05

### Implementation Decision
A user can clone the repo into their machine, local or cloud, edit the monitor/config/urls.txt file for their websites and intervals, then simply run bash monitor/bin/start_monitor.sh
The documentation will instruct users to run start_monitor any time they alter urls.txt
A user runs stop_monitor.sh to stop monitoring all websites (to stop monitoring one, the user alters urls.txt and runs start_monitor)

### Design Decisions
- start_monitor.sh now calls stop_monitor.sh at the beginning
  - Ensures cron jobs match current config/urls.txt
  - Handles removed URLs and updated intervals
- stop_monitor.sh fixed:
  - Removed UDAMonitor jobs safely even if none exist
  - Handles empty crontabs without failing (cross-platform)


## [Unreleased] v1.5 - 2026-02-05

### Problem
- The current scripts are over-complex now that cron enters the picture
- The user and cron should have two different entry points to the application.

### Added
- start_monitor.sh simply reads urls.txt and creates the cron jobs
- now run_monitor.sh does not cycle through urls, but runs on one url

### Changed
- returning now to passing an argument with run_monitor.sh to simplify cron

-----

## [Unreleased] v1.4 - 2026-02-05

### Problem (realized after the fact, unfortunately)
- The current scripts are not portable, as they require command-line arguments.

### Added
- Monitoring script now reads URLs from `urls.txt`, allowing multiple endpoints to be monitored without changing the script.

### Changed
- Removed requirement to pass URL as a command-line argument.

-----


## v2.x – EC2 Deployment
- Migrated monitoring job from local cron to EC2
- Introduced IAM role-based access
- Centralized logs in CloudWatch

## v1.x – Local Prototype
- Bash-based endpoint monitoring
- Cron-based scheduling
- Local logging
