## [Unreleased] v1.5 - 2026-02-05

### Problem
- The current scripts are over-complex now that cron enters the picture

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
