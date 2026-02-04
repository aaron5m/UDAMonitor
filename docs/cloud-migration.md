# Cloud Migration: Local Cron → EC2 with CloudWatch Logs

## Overview

This document describes the migration of UDAMonitor from a local, cron-based monitoring script to a cloud-hosted deployment running on AWS EC2. The goal of this phase was not to change application behavior, but to evolve the runtime environment toward a more production-like setup with clearer operational boundaries, centralized logging, and improved security practices.

This migration represents **Phase 2** of the project, following an initial local prototype.

---

## Motivation

The initial version of UDAMonitor was designed to run locally using a Bash script scheduled via cron. While this was sufficient for development and validation, it had several limitations:

- Execution depended on a local machine being online
- Logs were only available locally
- No clear separation between application logic and runtime environment
- No opportunity to demonstrate cloud operational practices

Migrating the job to EC2 addresses these limitations while keeping the system intentionally simple.

---

## High-Level Architecture

+--------------------+
| cron (EC2) |
+---------+----------+
|
v
+--------------------+
| Bash Monitor |
| (curl endpoint) |
+---------+----------+
|
v
+--------------------+
| Target Endpoint |
+--------------------+

Logs → CloudWatch Logs
Auth → IAM Role


---

## Key Design Decisions

### Why EC2?

EC2 was chosen to mirror the original local execution model as closely as possible:

- Full control over the OS and scheduling via cron
- Minimal abstraction compared to serverless or container-based approaches
- Easier mapping from “local Linux machine” to “cloud Linux machine”

This allowed the migration to focus on operational concerns rather than application rewrites.

---

### Why IAM Roles Instead of Static Credentials?

The EC2 instance uses an IAM role to interact with AWS services (specifically CloudWatch Logs). This avoids:

- Storing AWS credentials in the repository
- Managing credential rotation manually
- Risk of credential leakage

Role-based access reflects standard AWS security best practices and better approximates a production environment.

---

### Why CloudWatch Logs?

CloudWatch Logs was selected to centralize log output from the monitoring job:

- Logs are accessible without SSH access to the instance
- Provides a single source of truth for execution history
- Lays groundwork for future alerting or metrics

At this stage, logs are used primarily for visibility rather than automated alerting.

---

## Implementation Notes

- The EC2 instance runs a Linux distribution with cron configured to execute the monitoring script on a fixed schedule.
- The script logic remains unchanged from the local version.
- Script output is written to a log file that is shipped to CloudWatch Logs via the CloudWatch agent.
- Permissions are granted exclusively through the attached IAM role.

---

## Non-Goals for This Phase

The following were intentionally deferred:

- Infrastructure as Code (Terraform / CloudFormation)
- Autoscaling or high availability
- Alerting or notifications
- Containerization or serverless migration

These decisions were made to keep the scope focused on understanding core AWS primitives and operational tradeoffs.

---

## Tradeoffs and Future Improvements

This migration prioritizes clarity and learning over automation. While manual provisioning does not scale, it provides a clear understanding of the moving parts involved.

Future phases may include:
- Defining EC2 and IAM resources using Infrastructure as Code
- Adding alerting based on CloudWatch metrics
- Exploring alternative runtimes (containers or serverless)
- Hardening the instance (least-privilege IAM, logging retention policies)

---

## Summary

This phase demonstrates the transition from a local script to a cloud-hosted operational service while preserving simplicity. The focus was on environment, security, and observability rather than new features, reflecting real-world DevOps responsibilities.

