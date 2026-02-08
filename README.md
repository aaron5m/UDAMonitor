# UDAMonitor

UDAMonitor is a lightweight uptime and deployment health monitoring service designed for small teams, indie developers, and personal projects.

The goal of UDAMonitor is to provide simple, reliable visibility into whether an application is up, responsive, and behaving correctly — without the complexity or cost of large observability platforms.

This project is being built incrementally in public as a production-style DevOps system.

---

## Problem Statement

Many small applications lack basic operational visibility:
- Is the service up?
- Is it responding within acceptable latency?
- Did a recent deployment introduce an outage?
- When something breaks, how quickly do I find out?

Existing monitoring tools can be expensive, complex, or overkill for early-stage projects.

UDAMonitor focuses on solving this problem with a minimal, transparent, and infrastructure-first approach.

---

## Project Goals

- Perform automated HTTP uptime checks against configurable endpoints
- Measure availability and response latency
- Detect failures and degraded performance
- Log results in a structured, machine-readable format
- Send alerts via webhook or email when failures occur
- Be simple to deploy, operate, and extend

---

## Non-Goals (v1, v2)

To keep the scope realistic and focused, the following are explicitly out of scope for the initial versions:
- User authentication or accounts
- Billing or subscriptions
- Advanced dashboards or UI
- Multi-region high availability
- SLA guarantees

These may be explored in later iterations if the project evolves.

---

## Cloud Logging / Observability Architecture (v2.*)

UDAMonitor now supports **cloud-based logging via AWS CloudWatch**:

- Each EC2 instance runs the monitor script on a schedule (cron).
- Logs are written locally to `logs/monitor.log` **and streamed to CloudWatch**.
- EC2 instances are attached to an IAM role with `CloudWatchAgentServerPolicy` for secure logging.
- Centralized logs allow easy monitoring of uptime across instances.
- See the Wiki for example CloudWatch outputs and configuration.

## Local Architecture (v2.*)

**Status:** Local execution (development phase)

- Bash-based monitoring script
- Runs on a developer machine
- Executes HTTP checks against public endpoints
- Logs results to local files
- Designed to later run unattended on cloud infrastructure

This initial version prioritizes correctness, clarity, and portability over scale.

**Logging Architecture**

As of the latest update, logs are **segmented per monitored website** rather than written to a single central file.

Each website has its own dedicated log file, which provides:

- Clear isolation of monitoring data per target
- Easier debugging and incident investigation
- Reduced noise as the number of monitored sites scales
- A structure that aligns with future infrastructure and deployment plans

This approach mirrors common production monitoring patterns where services and targets emit isolated logs rather than sharing a global output.

### Console Log Viewer

View logs for the websites directly from the terminal with:
```
bash monitor/bin/watch_monitor.sh
```
Shows five most recent logs for each website.
The viewer is designed to integrate cleanly with cron-based execution and requires no additional dependencies beyond standard Unix tools.

### Design Notes

- Existing cron schedules and monitoring logic remain unchanged
- Log formats are consistent; only log file organization has been updated
- All functionality is implemented in Bash to match the current scope of the project

This logging model provides a foundation for future enhancements such as centralized log aggregation, cloud deployment (e.g., EC2), and containerized distributions.


--

## Repository Structure

<code>
UDAMonitor/
├── README.md
├── CHANGELOG.md
├── docs/
│ ├── installation-and-usage.md
│ └── cloud-migration.md
└── monitor/
  ├── bin/
  │ ├── start_monitor.sh
  │ ├── run_monitor.sh
  │ └── stop_monitor.sh 
  ├── lib/
  │ ├── parse_urls.sh
  │ ├── set_permissions.sh
  │ ├── verify_runtime_dirs.sh
  │ ├── http_check.sh
  │ └── logger.sh 
  ├── config/
  │ ├── urls.txt
  │ └── cloudwatch-agent.json
  ├── logs/
  │ └── monitor.log
  └── tmp/
</code>

---

## Roadmap

Planned evolution of the project:

1. **Local monitoring**
   - Bash-based HTTP checks [x] 2026-02-02
   - Structured logging
   - Cron-based scheduling

2. **Cloud deployment**
   - Run on AWS EC2
   - IAM-based permissions
   - Centralized logging

3. **Infrastructure as Code**
   - Terraform-managed infrastructure
   - Environment separation

4. **CI/CD**
   - Automated testing and deployment
   - Safe rollouts

5. **Containers & Kubernetes**
   - Containerized execution
   - Orchestrated deployments

6. **Observability & Reliability**
   - Metrics and alerting
   - SLOs and error budgets

---

## Why This Project Exists

This project serves two purposes:
1. Build a genuinely useful operational tool
2. Demonstrate real-world DevOps practices end-to-end

Design decisions, tradeoffs, and lessons learned are documented throughout the repository.

---

# Status

🚧 Actively under development  
Initial implementation focuses on core uptime checking and logging.

## Current State and Problems (EC2 CloudWatch Migration)

- UDAMonitor is now running on an EC2 instance.
- Initial deployment revealed:
  - EC2 instance lacked `git`, had to install manually
  - Cron service was missing, had to install manually
  - CloudWatch agent needed manual start and config
- These challenges motivated moving towards **Terraform automation**:
  - EC2 + IAM + CloudWatch provisioning
  - Automatic software installation via `user-data`
- Next steps (planned):
  1. Install Terraform locally and create first module for EC2 setup
  2. Automate UDAMonitor bootstrap (clone, permissions, start_monitor)
  3. Validate logs and cron jobs automatically
