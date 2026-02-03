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

## Non-Goals (v1)

To keep the scope realistic and focused, the following are explicitly out of scope for the initial versions:
- User authentication or accounts
- Billing or subscriptions
- Advanced dashboards or UI
- Multi-region high availability
- SLA guarantees

These may be explored in later iterations if the project evolves.

---

## Current Architecture (v1)

**Status:** Local execution (development phase)

- Bash-based monitoring script
- Runs on a developer machine
- Executes HTTP checks against public endpoints
- Logs results to local files
- Designed to later run unattended on cloud infrastructure

This initial version prioritizes correctness, clarity, and portability over scale.

---

## Current Progress (v1.2)
- `check.sh` script implemented in clean Bash
- Tracks HTTP status codes for multiple URLs
- Counts redirects for each URL
- Logs are stored in the `logs/` directory
- Basic clean Bash refactor complete:
  - Improved readability
  - Clear functions
  - Better variable handling
  - Redirect counting added
  
--

## Repository Structure

<code>
UDAMonitor/
├── README.md
├── docs/
│ ├── architecture.md
│ └── decisions.md
├── diagrams/
├── monitor/
│ ├── check.sh
│ └── config.env
│ └── logs/
├── scripts/
  └── install.sh
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

## Status

🚧 Actively under development  
Initial implementation focuses on core uptime checking and logging.

--

# INSTALLATION AND USAGE

1. **Clone the repo**

```bash
git clone https://github.com/<your-username>/UDAMonitor.git
cd UDAMonitor

2. **Set execute permissions for the script**

chmod +x check.sh

3. **Run the script**

./check.sh

4. **Check the logs**

Logs are saved in monitor/logs/ directory

Each entry includes:
Timestamp | URL | HTTP status | Redirect count
