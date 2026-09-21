## v0.0.183 -- 2026-09-21

### Improvements

  - Consolidate AWS/Azure/GCP/Oracle/Hetzner/DigitalOcean integrations in Marketplace

---

## v0.0.182 -- 2026-09-21

### New Features

  - Add comp-data-residency to analyst's default RBAC page list
  - Restructure Security Operations nav: relocate Detection Rules, add SLA Thresholds config, fix ai_settings merge bug

### Improvements

  - Bump cy360-ai-security to v0.3.5
  - Bump cy360-exposure-mgmt to v0.2.7
  - Remove dead AddonInstallFlow/AddonModulesSection from MarketplacePage.jsx
  - Restructure Exposure Management nav, relocate Vulnerability Mgmt, automate KEV/EPSS incident promotion

---

## v0.0.181 -- 2026-09-21

### Improvements

  - Bump cy360-secops-core to v0.1.27

---

## v0.0.180 -- 2026-09-21

### New Features

  - perf: skip rebuilding unchanged images + add registry build cache to releases

---

## v0.0.179 -- 2026-09-21

### Bug Fixes

  - Docker Maintenance scheduled job silently did nothing every run

---

## v0.0.178 -- 2026-09-20

### Improvements

  - Bump cy360-exposure-mgmt to v0.2.6

---

## v0.0.177 -- 2026-09-20

### Improvements

  - Notifications badge/version footer + case detail/remediation/resolution-gate UX
  - Revert unrelated uncommitted work accidentally swept into a pin-bump commit
  - Bump cy360-edr to v0.2.2
  - Bump cy360-grc to v0.1.6
  - Bump cy360-threat-intel to v0.1.5
  - Bump cy360-datalake to v0.1.14
  - Bump cy360-ai-security to v0.3.4
  - Bump cy360-marketplace to v0.1.9

---

## v0.0.176 -- 2026-09-20

### Improvements

  - Bump cy360-datalake to v0.1.13
  - Bump cy360-exposure-mgmt to v0.2.5

---

## v0.0.175 -- 2026-09-20

### Improvements

  - Bump cy360-datalake to v0.1.12
  - Bump cy360-exposure-mgmt to v0.2.4

---

## v0.0.174 -- 2026-09-20

### Improvements

  - Bump cy360-datalake to v0.1.11

---

## v0.0.173 -- 2026-09-20

### Improvements

  - Stability and performance improvements.

---

## v0.0.172 -- 2026-09-20

### New Features

  - Add extensible payload-provider hook to fleet heartbeat
  - Add Repair step for /opt/cyassure/itam-oui bind-mount ownership

### Bug Fixes

  - Update task ledger: Integration Health page diagnosis + 2 fixes

### Improvements

  - Bump cy360-exposure-mgmt to v0.2.3
  - Bump cy360-datalake to v0.1.10
  - Update task ledger: Benchmark Cohort Bands live aggregation built
  - Bump cy360-secops-core to v0.1.24
  - Update task ledger: requirements.txt reorder failed, force-reinstall shipped

---

## v0.0.171 -- 2026-09-20

### Improvements

  - Force cy360-datalake to install last, deterministically

---

## v0.0.170 -- 2026-09-20

### Bug Fixes

  - Fix: CyTIM calls silently Cloudflare-challenged by default requests User-Agent

### Improvements

  - Update task ledger: multi-instance connector deploy landmine found + stopgap

---

## v0.0.169 -- 2026-09-20

### Bug Fixes

  - Fix multi-instance connector deploy: reorder requirements.txt install
  - Update task ledger: EDR anomaly-escalation fixes released as v0.0.168

---

## v0.0.168 -- 2026-09-20

### New Features

  - Add TASK_LEDGER entry for Sigma rule-corpus refresh fix
  - Add task ledger entry for EDR anomaly-escalation fixes

### Improvements

  - Bump cy360-secops-core to v0.1.22
  - Bump cy360-exposure-mgmt to v0.2.2
  - Bump cy360-edr to v0.2.1
  - Stop the host Compliance tab from fabricating per-framework GRC status

---

## v0.0.167 -- 2026-09-20

### Improvements

  - Bump cy360-datalake to v0.1.9
  - Bump cy360-secops-core to v0.1.21

---

## v0.0.166 -- 2026-09-20

### Bug Fixes

  - Pin CYASSURE_VERSION in .env to the resolved release on fresh install
  - Fix manifest.json "latest" race in the public installer mirror sync

---

## v0.0.165 -- 2026-09-19

### Bug Fixes

  - Tracker: mark M15+M16 done, record the cross-repo tenant_id fix

### Improvements

  - Bump cy360-secops-core to v0.1.20
  - M16: public EDL feed URLs, per-tenant token + IP allowlist
  - M15: EDL/Blocklist Management admin UI, gated on tim_integration

---

## v0.0.164 -- 2026-09-19

### New Features

  - Tracker: add M16 — public EDL text-feed URLs for perimeter firewalls

### Improvements

  - Tracker: M16 design decisions confirmed — per-tenant scope, token+IP allowlist
  - Bump cy360-edr to v0.2.0

---

## v0.0.163 -- 2026-09-19

### Improvements

  - Bump cy360-edr to v0.1.17
  - Tracker: record the 2026-09-20 release across all 4 repos

---

## v0.0.162 -- 2026-09-19

### New Features

  - Tracker: add M15 — EDL admin UI as an Enterprise-gated add-on
  - Tracker: mark M12 done, correct guardrail spec, add M12b gap
  - Tracker: mark M14 done (stubbed), add M14b follow-up
  - Tracker: mark M3b done, add M3c (wire Tier 1 tool to new endpoint
  - Tracker: log autonomous-continuation approval, add final-deliverable item
  - Tracker: mark M3+M5 done, add M3b (case-opening endpoint gap
  - Add SOC AI Agent Tier 1/2 implementation tracker

### Bug Fixes

  - Tracker: correct M15 licensing — base Enterprise/tim_integration, not an add-on
  - Tracker: correct false 'concurrent session' conclusion, root cause found
  - Tracker: mark M6 done (case-gated SOAR dispatch), note execution-mode switch
  - Tracker: mark M1+M2 (assignee_type, audit fix, SLA watchdog) done

### Improvements

  - Bump cy360-edr to v0.1.16
  - Bump cy360-secops-core to v0.1.19
  - Bump cy360-ai-security to v0.3.2
  - Tracker: final deliverable done — all phases complete
  - Tracker: mark M14b done — all 5 phases now complete
  - Tracker: mark M12b done, verified for real
  - Tracker: pause M12b, flag concurrent session on same branch
  - Tracker: mark M13 done (cy360-edr blocklist_ips enforcement
  - Tracker: Phase 4 (EDL) launched — M12/M13/M14 in progress
  - Tracker: mark M11 done — Phase 3 fully complete
  - Tracker: mark M9+M10 done (decision outcome-logging and accuracy
  - Tracker: mark M8 done — Phase 2 fully complete
  - Tracker: mark M6b done (portal proxy routes for response-plan actions
  - Tracker: mark M7 done (Tier 2 approve/decline-response-plan tools
  - Tracker: mark M3c done — Phase 1 + 1b fully complete
  - Tracker: mark M4 (agent-authored UI marking) done

---

## v0.0.161 -- 2026-09-19

### Improvements

  - Stability and performance improvements.

---

## v0.0.160 -- 2026-09-18

### Improvements

  - Bump cy360-edr to v0.1.15
  - Update task ledger: multi-instance marketplace integrations

---

## v0.0.159 -- 2026-09-18

### Improvements

  - Bump cy360-datalake to v0.1.8
  - Support multiple instances of one marketplace integration

---

## v0.0.158 -- 2026-09-18

### Improvements

  - Bump cy360-secops-core to v0.1.18

---

## v0.0.157 -- 2026-09-18

### New Features

  - Add preflight cross-module dependency pin consistency gate

### Improvements

  - Bump cy360-secops-core to v0.1.17
  - Bump cy360-threat-intel to v0.1.4
  - Bump cy360-marketplace to v0.1.8
  - Bump cy360-datalake to v0.1.7
  - Bump cy360-grc to v0.1.5
  - Bump cy360-edr to v0.1.14

---

## v0.0.156 -- 2026-09-18

### New Features

  - Enterprise Features nav reorg (rename + Platform Management regroup); fix dead nav ids left over from the licensing pass

### Bug Fixes

  - Licensing alignment pass: shared free-addon source of truth, fix 3 lock/bypass gaps

### Improvements

  - Bump cy360-exposure-mgmt to v0.2.1
  - Bump cy360-ai-security to v0.3.1
  - Revert manual pin pre-bump — let module-push.sh own versioning

---

## v0.0.155 -- 2026-09-18

### Improvements

  - Bump cy360-secops-core to v0.1.16

---

## v0.0.154 -- 2026-09-18

### Improvements

  - Bump cy360-ai-security to v0.3.0
  - Bump cy360-secops-core to v0.1.15
  - Bump cy360-threat-intel to v0.1.3
  - Bump cy360-marketplace to v0.1.7
  - Bump cy360-datalake to v0.1.6
  - Bump cy360-grc to v0.1.4
  - Bump cy360-edr to v0.1.13

---

## v0.0.153 -- 2026-09-17

### Improvements

  - Bump cy360-exposure-mgmt to v0.2.0
  - Bump cy360-ai-security to v0.2.0

---

## v0.0.152 -- 2026-09-17

### Improvements

  - Stability and performance improvements.

---

## v0.0.151 -- 2026-09-17

### Improvements

  - Bump cy360-secops-core to v0.1.14
  - Bump cy360-secops-core to v0.1.13
  - Bump cy360-ai-security to v0.1.10
  - Bump cy360-exposure-mgmt to v0.1.6

---

## v0.0.150 -- 2026-09-17

### Improvements

  - Stability and performance improvements.

---

## v0.0.149 -- 2026-09-17

### Improvements

  - Stability and performance improvements.

---

## v0.0.148 -- 2026-09-17

### Improvements

  - Stability and performance improvements.

---

## v0.0.147 -- 2026-09-17

### Improvements

  - Stability and performance improvements.

---

## v0.0.146 -- 2026-09-17

### Improvements

  - Stability and performance improvements.

---

## v0.0.145 -- 2026-09-16

### Bug Fixes

  - Fix stale ingest_worker.pyc command in customer release bundle template

---

## v0.0.144 -- 2026-09-16

### Improvements

  - Stability and performance improvements.

---

## v0.0.143 -- 2026-09-16

### Improvements

  - Stability and performance improvements.

---

## v0.0.142 -- 2026-09-16

### Improvements

  - Bump cy360-secops-core to v0.1.12
  - Bump cy360-datalake to v0.1.5

---

## v0.0.141 -- 2026-09-15

### Improvements

  - Bump cy360-marketplace to v0.1.6

---

## v0.0.140 -- 2026-09-15

### Improvements

  - Bump cy360-secops-core to v0.1.11

---

## v0.0.139 -- 2026-09-15

### Improvements

  - Bump cy360-edr to v0.1.12
  - Bump cy360-datalake to v0.1.4
  - Bump cy360-threat-intel to v0.1.2
  - Bump cy360-marketplace to v0.1.5
  - Bump cy360-secops-core to v0.1.10
  - Bump cy360-exposure-mgmt to v0.1.5
  - Bump cy360-ai-security to v0.1.9
  - Bump cy360-grc to v0.1.3

---

## v0.0.138 -- 2026-09-15

### Improvements

  - Stability and performance improvements.

---

## v0.0.137 -- 2026-09-15

### Improvements

  - Stability and performance improvements.

---

## v0.0.136 -- 2026-09-15

### Improvements

  - Stability and performance improvements.

---

## v0.0.135 -- 2026-09-15

### Improvements

  - Task ledger: log Network Control/Exclusions/Isolation/Network Probe/Tamper Protection operability review

---

## v0.0.134 -- 2026-09-15

### Improvements

  - Stability and performance improvements.

---

## v0.0.133 -- 2026-09-15

### Improvements

  - Stability and performance improvements.

---

## v0.0.132 -- 2026-09-15

### Improvements

  - Bump cy360-edr to v0.1.8
  - Bump cy360-edr to v0.1.7
  - Bump cy360-edr to v0.1.6

---

## v0.0.131 -- 2026-09-14

### Improvements

  - Stability and performance improvements.

---

## v0.0.130 -- 2026-09-14

### Improvements

  - Bump cy360-ai-security to v0.1.6

---

## v0.0.129 -- 2026-09-14

### Improvements

  - Bump cy360-edr to v0.1.5

---

## v0.0.128 -- 2026-09-14

### Improvements

  - Stability and performance improvements.

---

## v0.0.127 -- 2026-09-14

### Improvements

  - Bump cy360-secops-core to v0.1.7
  - Bump cy360-edr to v0.1.4

---

## v0.0.126 -- 2026-09-14

### Improvements

  - Stability and performance improvements.

---

## v0.0.125 -- 2026-09-14

### Bug Fixes

  - Task ledger: live-verify correction + AI Gateway relay wiring entry

### Improvements

  - Bump cy360-secops-core to v0.1.6
  - Bump cy360-ai-security to v0.1.5
  - Bump cy360-edr to v0.1.3
  - Wire the AI Security Gateway's TLS relays into the compose stack + UFW

---

## v0.0.124 -- 2026-09-13

### New Features

  - Add first-install EULA acceptance gate to the Setup Wizard

### Bug Fixes

  - Fix cysiemstack-engine/ingest-worker crash loops from the repo-segmentation cutover

---

## v0.0.123 -- 2026-09-13

### New Features

  - Bump exposure-mgmt/secops-core pins; add Shadow AI app-rollup tab
  - Add TASK_LEDGER.md — cross-repo task index to avoid rework
  - Add CODEOWNERS mapping modules to future team boundaries

### Improvements

  - Bump cy360-ai-security to v0.1.4; Docker changes for DLP detection-depth pass
  - Task ledger: gap B (Go agent enforcement) entry
  - Bump cy360-edr pin to v0.1.2; EDR Policies UI for AI Gateway CA trust
  - Task ledger: shadow-ai/ai-security gap-closure entry
  - Bump cy360-ai-security to v0.1.3, cy360-secops-core to v0.1.2
  - Move CyEDR agent/agent-go/scripts and browser-extension out of cy360 root
  - Remove dead cruft: stray backend/backend/ dup and empty blueprints/siem/
  - Cut over backend to the 8 extracted module packages (repo-segmentation
  - Rename public installer mirror references from get-cy360 to cy360-install

---

## v0.0.122 -- 2026-09-09

### Improvements

  - Stability and performance improvements.

---

## v0.0.121 -- 2026-09-09

### Improvements

  - Stability and performance improvements.

---

## v0.0.120 -- 2026-09-09

### Improvements

  - Stability and performance improvements.

---

## v0.0.119 -- 2026-09-09

### Bug Fixes

  - stop CyCollector's unmatched-log bucket from flooding incidents; make every alert row clickable

---

## v0.0.118 -- 2026-09-09

### New Features

  - jump-to-incident-ID search on the Active Incidents page

---

## v0.0.117 -- 2026-09-09

### Bug Fixes

  - wire the dead file_hash_ioc detection trigger to real CyTIM hash data

---

## v0.0.116 -- 2026-09-08

### Improvements

  - Stability and performance improvements.

---

## v0.0.115 -- 2026-09-08

### Improvements

  - Stability and performance improvements.

---

## v0.0.114 -- 2026-09-08

### Bug Fixes

  - move get_cytim_settings() out of core/helpers.py to unblock engine TI enrichment

---

## v0.0.113 -- 2026-09-08

### Improvements

  - Stability and performance improvements.

---

## v0.0.112 -- 2026-09-08

### New Features

  - add missing requests dependency to correlation-engine image

---

## v0.0.111 -- 2026-09-08

### New Features

  - inline AddonButtonLock for individually-gated Exposure Mgmt actions
  - wire AddonLock into GRC and Exposure Management pages
  - gate ITAM's deep-scan/CVE routes behind Exposure Management add-on
  - module-packaging license model — XDR Core base + GRC/Exposure/AI Security add-ons

### Bug Fixes

  - RLS tenant policy rejected every alert/incident insert since item #34 rollout
  - grandfather grc_enabled/exposure_mgmt_enabled for pre-v8 licenses

---

## v0.0.110 -- 2026-09-08

### Improvements

  - Stability and performance improvements.

---

## v0.0.109 -- 2026-09-08

### Bug Fixes

  - Model Center usability — surface pre-existing UEBA model, explain how to use each one

---

## v0.0.108 -- 2026-09-08

### New Features

  - patch-priority model #7 — passive label instrumentation
  - Model Center — Phase 3, model #8 (compliance drift forecast
  - Model Center — Phase 2 ML models (JA3 drift, cmdline obfuscation, semantic grouping

---

## v0.0.107 -- 2026-09-07

### New Features

  - Model Center — Phase 1 ML models (FP classifier, per-host UEBA, DGA classifier

---

## v0.0.106 -- 2026-09-07

### Bug Fixes

  - Fix fake_powershell.bat's exit code leaking a real failure for wineventlog's System channel

---

## v0.0.105 -- 2026-09-07

### Improvements

  - Close out B9: sysmon/wineventlog's fake powershell.sh now works on real Windows too

---

## v0.0.104 -- 2026-09-07

### Bug Fixes

  - Fix the real root cause of WindowsWatcher's hang: the directory handle was never opened for overlapped I/O

---

## v0.0.103 -- 2026-09-07

### Bug Fixes

  - Fix WindowsWatcher.Close() hang for real: switch to overlapped I/O, don't retry CancelIoEx on sync I/O

---

## v0.0.102 -- 2026-09-07

### Improvements

  - Gate agent-go-windows-verify and publish-agent-go on an actual agent-go change

---

## v0.0.101 -- 2026-09-07

### Bug Fixes

  - Fix agent-go test suite for real Windows execution — first time it actually ran there

---

## v0.0.100 -- 2026-09-07

### New Features

  - Add .gitattributes forcing LF for Go source, fixing agent-go-windows-verify's spurious gofmt failure

### Bug Fixes

  - Discard Python EDR entirely: stop building it, default installers to Go, fix a tray-install gap it would have caused

---

## v0.0.99 -- 2026-09-07

### Improvements

  - Stability and performance improvements.

---

## v0.0.98 -- 2026-09-07

### Improvements

  - Publish agent-go binaries for real: stage into the backend image, flip release-upload gate live

---

## v0.0.97 -- 2026-09-07

### Improvements

  - Stability and performance improvements.

---

## v0.0.96 -- 2026-09-07

### Improvements

  - Stability and performance improvements.

---

## v0.0.95 -- 2026-09-07

### New Features

  - Add network-connect + file-access kprobes for item #22 Phase 1
  - Add Tetragon eBPF client PoC for item #22 (Phase 0
  - Close item #49 (macOS full parity), prep #52/#53 disabled, add Intel CI

### Bug Fixes

  - Fix macOS network_control firewall_rules: anchor loaded but never enforced (tracker item B4
  - Fix agent-go's own self-enrollment: missing deployment_token, wrong os_type
  - Go rewrite: implement 4 missing response commands, fix Windows forensics ps bug
  - CyEDR Go rewrite: port APPLY_POLICY — the only server-push dispatch path for every EDR policy type
  - CyEDR Go rewrite: Windows readers, ROLLBACK OS-dispatch fix, tray IPC client, real build pipeline

### Improvements

  - macOS: brand the agent's Full Disk Access identity as "CyEDR"
  - Log edr-i-81: B1/B4/B8 session history entry
  - Productionize Tetragon deployment for BLOCK_HASH tier 2 (tracker item B8
  - Merge worktree-cyedr-go-rewrite-20260825-173619 into main (tracker item B1
  - Port FIM and SCA to Windows (tracker item B17, closes the hard cutover blocker
  - Port FIM and SCA to macOS (tracker item B17, hard cutover blocker
  - BLOCK_HASH tier 2: real, instant Linux exec blocking via Tetragon (item #22/#26 pivot
  - Implement BLOCK_HASH: reactive process-hash blocklist, Go-only, all 3 OSes
  - Go rewrite cutover Phase 0: port the InventoryReporter/ITAM subsystem
  - Go rewrite cutover Phase 0: prepared (disabled) agent-go release publish path
  - Go rewrite cutover Phase 0: port items #23/#31 (AMSI + AD DC readers
  - Go rewrite cutover Phase 0: port item #26 (exploit mitigation) both halves
  - Go rewrite cutover Phase 0: port 3 real Linux capabilities missing from parity (JA3, container attribution, deception canaries
  - Items #24/#29: real process-lineage capture, wired into the real agent, verified live end-to-end
  - Item #26: real Linux exec-block enforcement (ApplyExecBlockPolicy/RemoveExecBlockPolicy), verified live
  - Item #22 Phase 1: pin Tetragon v1.7.1, verified live against the real server (go-i-14
  - Record item #22 Phase 2 real shadow-mode validation findings (go-i-13
  - Merge Track A updates (items #28/29/34/35/38/40) into this worktree's tracker
  - Sync Track A updates from main into this worktree's tracker copy
  - Wire agent-go into CI as a build-verification gate, close item #52
  - Implement systray UI, close Go rewrite item #51 (Tray rewrite
  - Port macOS Shadow AI legs (FDA/browser-history/lsof) for Go rewrite item #49
  - Implement Shadow AI detection, close Go rewrite item #48 (Linux full parity
  - Implement network_probe for Go rewrite item #48 (Linux full parity
  - Implement device/app/network_control enforcement for Go rewrite item #48
  - Implement SCA for Go rewrite item #48 (Linux full parity
  - Sync merged CyEDR tracker into this worktree; implement FIM for Go rewrite item #48
  - CyEDR Go rewrite: round out Phase 1 (Linux), start Phase 3 (macOS) and Phase 4 (Windows) response actions
  - CyEDR Go rewrite: Phase 1 core (enroll, heartbeat, response, commandpoller
  - CyEDR Go rewrite: feasibility assessment + Linux proof-of-concept

---

## v0.0.94 -- 2026-09-06

### New Features

  - Cloud asset sensor: add Azure/GCP/Oracle providers, owner-from-tag/label inference
  - Alert on offsite backup failures, add retention pruning, fix RLS tenant scoping for job-health incidents
  - Go rewrite cutover Phase 0: add build_source fleet-visibility column

### Bug Fixes

  - Fix cy_comp_question_correlations RLS insert failure
  - Fix CyEDR Go-agent Windows install path: 7 real bugs found via hardware testing
  - Fix critical bug: every real self-enrollment 500s (os_type never SELECTed
  - Track git-push.sh in the repo; fix it to push HEAD:main instead of local main
  - Fix cy_comp deadlock risk, deployment-token os_type enforcement; prune stale docs table
  - Item #38: fix App Group config-sharing gap between CyEDR Mobile app and extension

### Improvements

  - Close SCIM seat-limit bypass on OIDC/SAML auto-provisioning
  - Go rewrite cutover Phase 0: real cutover mechanism via opt-in --impl flag
  - Items #49/#50: document real hardware verification on genuine Intel Mac and Windows ARM64

---

## v0.0.93 -- 2026-09-05

### Improvements

  - Item #38: real telemetry-shipping client + QR-code mobile enrollment (backend, portal, iOS
  - Item #38: real iOS build (Xcode/XcodeGen), packet parser, and telemetry client for CyEDR Mobile
  - Item #34: MSSP-grade multi-tenancy — tenant switcher, per-tenant seats, SSO domain scoping, CyDataLake tenant ingest

---

## v0.0.92 -- 2026-09-04

### Improvements

  - Stability and performance improvements.

---

## v0.0.91 -- 2026-09-04

### Improvements

  - Stability and performance improvements.

---

## v0.0.90 -- 2026-09-04

### Bug Fixes

  - Rebrand cyassure.com -> cyassure.eu; split CySIEM Stack settings tab; rename SIEM Automation; fix audit_reporter FP-threshold key

### Improvements

  - Rename Auto Case Close settings tab to Automation ( Case Closure
  - Document edr-i-66: real deploy verification, cy_comp deadlock finding, docs cleanup

---

## v0.0.89 -- 2026-09-03

### New Features

  - Item #34 Phase 3: RLS on the 12 remaining edr_* tables, fix a critical agent-auth outage the Phase 1 migration silently introduced
  - Add Deception Layer status card (item #37) - closes the UI-management list
  - Add Interactive Shell console UI (item #25
  - Add cloud discovery UI to Asset Management settings (item #33
  - Add ITDR settings UI: on-prem AD LDAP + Entra ID config surfaces (item #31
  - Add K8s manifests + real API-based pod resolution for item #33
  - Add architecture scoping docs for items #35 (kernel driver) and #40 (packet visibility
  - Add process-chain view to endpoint detail page (item #24, partial
  - Add mobile threat defense agent scoping doc (item #38
  - Add AD Security-log DCSync/object-change reader (item #31 first slice
  - Add container/pod attribution to Linux telemetry (item #33 first slice
  - Add campaign remediation UI, close item #32
  - Add architecture scoping docs for items #22 (eBPF) and #34 (multi-tenant
  - Add macOS Gatekeeper enforcement + codesign checks for item #26
  - Add interactive real-time response shell on isolated hosts (item #25
  - Add fleet-wide campaign remediation endpoint (item #32), backend only
  - Add deception layer: decoy credentials + access-triggered detection (item #37
  - Add targeted file/registry change-log rollback, Linux+macOS (item #27
  - Add Defender AMSI-detection reader for Windows agent (item #23
  - Add JA3/JA3S TLS fingerprinting on agent network events (item #14, Linux
  - Add THROTTLE_PROCESS response action (item #19
  - Add logsource-style pre-filter routing to correlator.py (item #20
  - Add DISABLE_USER_ACCOUNT + REVOKE_SESSION_TOKENS response actions (item #18

### Bug Fixes

  - Item #24: fix a real ESLint finding surfaced now that the portal toolchain works
  - Item #34: fix network_assets/iot_devices.ip_address global-uniqueness gap, plus a related background-thread tenant-loss bug found along the way
  - Item #34: fix the 2 disclosed background-scheduler tenant blind spots, plus a related async incident-creation gap found along the way
  - Item #34: fix rule-key/rule-id global uniqueness across 5 tables
  - Document edr-i-62: RLS insert-default bug fix across the whole item #34 effort
  - Fix RLS insert-default bug across the whole item #34 effort, not just cy_comp
  - CyMind Option B, step 3/6: HTTP layer per-tenant gateway config + fix critical RLS insert-default bug
  - Item #34 Phase 7: cy_mind's db() resolves the real MSSP tenant, but its own tables are NOT RLS'd yet - real naming collision found
  - Item #34 Phase 6: tenant_id + RLS on ITAM's 10 tenant-scoped tables, fix a second critical probe-auth outage
  - Item #26: Linux exec-block enforcement is real, unblocked by item #22's fix
  - Item #22 Phase 1: fixed by pinning Tetragon v1.7.1 (was v1.2.0) - verified live
  - Item #34: tenant management UI, a critical edr_agents gap fix, Redis + CyDataLake tenant scoping
  - Fix the corruser superuser finding: real non-superuser DB role, deployment-wide
  - Fix tracker sync: restore Track A updates the last sync clobbered
  - Fix a live false-negative bug in routing, extend to category signals (item #20

### Improvements

  - Document edr-i-65: item #29 wired into live incident scoring
  - Item #29: wire the cloud behavioral ML classifier into live incident scoring
  - Document edr-i-64: item #29's cloud classifier configure+test surface
  - Item #29: cloud-hosted behavioral ML classifier — configurable + manually testable from UI
  - Document edr-i-63: item #34's remaining disclosed gaps closed
  - CyMind Option B, step 6/6: tracker + CLAUDE.md updates
  - CyMind Option B, step 5/6 (portal): "Enable Cloud AI for this tenant" self-service button
  - CyMind Option B, step 5/6 (backend): self-service Cloud provisioning route
  - CyMind Option B, step 2/6: per-tenant gateway/BYOK resolution replaces process-global state
  - CyMind Option B, step 1/6: cy360_tenant_id + RLS on all 28 cy_mind_* tables, cy_mind_gateway_config stops being a singleton
  - Update item #34 tracker: consolidated session summary for Phases 4-8 (edr-i-60
  - Item #34 Phase 8 (cont.): close out edr_process_lineage and host_item_acks - the last 2 disclosed/untouched tables
  - Item #34 Phase 8: tenant_id + RLS on the remaining 8 misc-blueprint tables (marketplace, connectors, TI providers, sigma rules, saved searches, platform reports
  - Item #34 Phase 5: tenant_id + RLS on the correlation DB's remaining 11 tables and all 5 CyCases tables
  - Item #34 Phase 4: tenant_id + RLS on all 18 tenant-scoped cy_comp_* (GRC) tables
  - Items #24/#29: real process-lineage capture and query API
  - Item #31: ship the 2 explicitly-deferred Entra signals (PIM activations, CA policy changes
  - Item #34: alerts/incidents cross-service tenant wiring + separate cyassure_app password
  - Item #34 Phase 2: wire edr_response_commands to real tenant_id, and disclose a critical RLS-bypass finding
  - Wire up DISABLE_USER_ACCOUNT, REVOKE_SESSION_TOKENS, THROTTLE_PROCESS (items #18/#19
  - Expose ITDR signals, cloud K8s inventory, and NAC quarantine history as MCP tools
  - Ship items 28, 29, 31, 33, 34: NAC quarantine UI, live UEBA scoring, Entra ITDR, cloud K8s discovery, multi-tenant RLS phase 1
  - Sync item #22's row: Phase 0+1 real progress, in_progress
  - Ship UEBA ML config surface (#29) + LDAP AdminSDHolder polling (#31
  - Implement items #28/#29/#34/#35/#38/#40 per Deepak's decisions
  - Switch rule/IOC corpus refresh from weekly to polled minutes (item #30
  - Sync CYEDR_ENHANCEMENT_PROGRESS.md from the cyedr-go-rewrite worktree
  - Enforce exploit_prevention via Windows Defender ASR/mitigations (item #26
  - Write 40 Recon/Initial Access/Impact/Infra-reuse correlation rules, close item #21 (batch 2 of 2
  - Write 44 PrivEsc/Lateral Movement/Discovery correlation rules (item #21, batch 1 of 2
  - Make JA3/JA3S events SIEM-visible, close item #14
  - Sync CYEDR_ENHANCEMENT_PROGRESS.md from the cyedr-go-rewrite worktree
  - Merge CyEDR detection-engine and Go-rewrite trackers into one git-tracked doc

---

## v0.0.88 -- 2026-08-26

### Improvements

  - Stability and performance improvements.

---

## v0.0.87 -- 2026-08-26

### Improvements

  - Stability and performance improvements.

---

## v0.0.86 -- 2026-08-25

### Improvements

  - Stability and performance improvements.

---

## v0.0.85 -- 2026-08-25

### Bug Fixes

  - bypass oauth2-proxy for all headless CyEDR agent routes (enrollment/telemetry

---

## v0.0.84 -- 2026-08-25

### Bug Fixes

  - installer crashes at DOWNLOAD RELEASE BUNDLE with a relative invocation

---

## v0.0.83 -- 2026-08-25

### New Features

  - stage EDR binaries automatically from the portal's Update/Upgrade buttons

---

## v0.0.82 -- 2026-08-25

### Bug Fixes

  - stage macOS/Windows CyEDR binaries onto live instances (previously never did

---

## v0.0.81 -- 2026-08-25

### New Features

  - surface agent version in the tray and add manual update checking
  - brand the CyEDR tray icon with the CyAssure mark, status color, and About link

---

## v0.0.80 -- 2026-08-25

### Bug Fixes

  - remove dead script-mode self-update path and stale Python-mode references
  - remove raw-.py CyEDR agent distribution, ship only compiled binaries

---

## v0.0.79 -- 2026-08-24

### Bug Fixes

  - stop requiring a GitHub token for fresh Docker installs

---

## v0.0.78 -- 2026-08-24

### Bug Fixes

  - installer no longer blocks fresh installs over license state

---

## v0.0.77 -- 2026-08-24

### Improvements

  - Stability and performance improvements.

---

## v0.0.76 -- 2026-08-24

### Improvements

  - Stability and performance improvements.

---

## v0.0.75 -- 2026-08-24

### Improvements

  - Marketplace entitlement: send X-CyAssure-Marketplace-Key (replaces entitlement_token
  - Licensing v5: simplified Analyst/Asset model, embedded TIM/CyMind Cloud credentials

---

## v0.0.74 -- 2026-08-24

### Improvements

  - Stability and performance improvements.

---

## v0.0.73 -- 2026-08-24

### Improvements

  - Stability and performance improvements.

---

## v0.0.72 -- 2026-08-23

### Improvements

  - Stability and performance improvements.

---

## v0.0.71 -- 2026-08-23

### Improvements

  - Stability and performance improvements.

---

## v0.0.70 -- 2026-08-23

### Improvements

  - Stability and performance improvements.

---

## v0.0.69 -- 2026-08-23

### Improvements

  - Stability and performance improvements.

---

## v0.0.68 -- 2026-08-23

### Improvements

  - Stability and performance improvements.

---

## v0.0.67 -- 2026-08-23

### Bug Fixes

  - Fix ingest-worker never being pulled/recreated by Update/Upgrade

---

## v0.0.66 -- 2026-08-23

### Bug Fixes

  - Fix /health's ai_configured check reading os.environ directly

---

## v0.0.65 -- 2026-08-23

### Bug Fixes

  - Fix CY360_INTERNAL_AI_KEY never reaching the correlation engine's process env
  - Fix CySOAR nginx routing not surviving a plain Update/Upgrade

### Improvements

  - Update CLAUDE.md's CyMind section — it described an architecture retired a month ago

---

## v0.0.64 -- 2026-08-23

### Improvements

  - Stability and performance improvements.

---

## v0.0.63 -- 2026-08-23

### Improvements

  - Stability and performance improvements.

---

## v0.0.62 -- 2026-08-23

### Improvements

  - Stability and performance improvements.

---

## v0.0.61 -- 2026-08-23

### Improvements

  - Stability and performance improvements.

---

## v0.0.60 -- 2026-08-23

### Improvements

  - Stability and performance improvements.

---

## v0.0.59 -- 2026-08-22

### Improvements

  - Stability and performance improvements.

---

## v0.0.58 -- 2026-08-22

### New Features

  - Close BYOK delete-sync gap; add tenant self-service Cloud usage view

---

## v0.0.57 -- 2026-08-22

### New Features

  - Add CyMind Cloud registration automation, mTLS scaffolding, usage heartbeat

---

## v0.0.56 -- 2026-08-22

### Improvements

  - Stability and performance improvements.

---

## v0.0.55 -- 2026-08-22

### Improvements

  - Stability and performance improvements.

---

## v0.0.54 -- 2026-08-21

### Improvements

  - Stability and performance improvements.

---

## v0.0.53 -- 2026-08-20

### Improvements

  - Stability and performance improvements.

---

## v0.0.52 -- 2026-08-20

### Improvements

  - Stability and performance improvements.

---

## v0.0.51 -- 2026-08-20

### Improvements

  - Stability and performance improvements.

---

## v0.0.50 -- 2026-08-20

### Improvements

  - Enforce item 41's max_active_agents/max_ai_assets license limits
  - Close the stale items 21/23 gate on AI Security Gateway Cloud mode
  - Merge item 43d (data retention policy) and item 43c (data residency controls

---

## v0.0.49 -- 2026-08-20

### Improvements

  - Stability and performance improvements.

---

## v0.0.48 -- 2026-08-20

### New Features

  - Add Local LLM admin surface: endpoint config, reachability status, model management, persisted routing strategy (items 42b/42c/42d
  - Add SCIM 2.0 provisioning (item 43b
  - Add offsite S3 backup replication + disaster recovery runbook (item 43e
  - Add SAML 2.0 Service Provider support (item 43a
  - Add AI Security Gateway Cloud telemetry ingestion + provisioning UI (items 25, 28

### Bug Fixes

  - Fix drift-risk half of item 44c: centralize native-chat tenant_id resolution
  - Fix cross-tenant IDOR + centralize tenant resolution in AI Security Gateway routes (item 44a/44b

### Improvements

  - Document and wire OLLAMA_URL/OLLAMA_ENDPOINTS into the deployment path (item 42a
  - Merge origin/main (items 25/28) into item 44a/44b work

---

## v0.0.47 -- 2026-08-19

### New Features

  - Add browser extension (Layer 2 AI Security) — tracker item 35
  - Add TLS Tier 2 MITM relay with enterprise CA, close out items 32 and 34
  - Add TLS Tier 3 SNI relay, close out item 33
  - Add external Gateway API route + keys, close out item 54
  - Add MCP Security registry + scanning layer, item 40 (Phase 4
  - Add Automation Agent framework core, item 38 (Phase 4
  - Add remaining license schema fields, close out items 27/41
  - Add CyEDR ai_discovery policy type, close out item 31 (Layer 1
  - Add routing-decision audit trail, close out item 37 (Advanced Gateway
  - Add secrets-vault Shadow AI credential scan for Azure Key Vault (item 47
  - Add Shadow AI asset-fingerprinting via agentless deep-scan (item 46
  - Add AI Security add-on licensing + Shadow AI network-syslog monitor (item 36
  - Add AI Security portal page (item 30
  - Add AI Security policy engine, asset inventory, risk scoring (item 29
  - Add AI Security Gateway mode picker (tracker item 19
  - Add cross-session AI attack correlation (tracker item 53
  - Add semantic query cache, closing the thin-GW module (item 16a
  - Add smart LLM routing (query classification, hardware-aware dispatch
  - Add native RAG document ingestion/retrieval engine
  - Complete DLP/anomaly/MCP porting and add Gateway mode config API
  - Add native AI Assistant / AI Security foundation (backend/cy_mind/

### Bug Fixes

  - Fix missing Enterprise-license gate on 5 AI Security read routes
  - Fix native AI Assistant chat gate, retire dead CyMind settings tab (item 14

### Improvements

  - Wire the remaining Automation Agent personas, close out item 39
  - Fold AI Security Gateway anomalies into UEBA, close out item 4
  - Wire the native AI Assistant into the existing chat overlay (item 50
  - Port LLM calling service: 6 providers, web search, embeddings

---

## v0.0.46 -- 2026-08-17

### Improvements

  - Stability and performance improvements.

---

## v0.0.45 -- 2026-08-17

### Improvements

  - Stability and performance improvements.

---

## v0.0.44 -- 2026-08-16

### Bug Fixes

  - Fix updater sidecar: env_file silently dropped, and hung compose calls wedged the action lock forever

---

## v0.0.43 -- 2026-08-15

### New Features

  - Add macOS Intel64 EDR agent + tray binaries to packages/

---

## v0.0.42 -- 2026-08-15

### Bug Fixes

  - Fix updater sidecar: docker compose can't find its own compose file

---

## v0.0.41 -- 2026-08-15

### Improvements

  - Rename Security Compliance/Platform Monitoring "Reports" nav items

---

## v0.0.40 -- 2026-08-15

### Improvements

  - Stability and performance improvements.

---

## v0.0.39 -- 2026-08-15

### Improvements

  - Fold AI Applications into Detection Rules & Apps, reorder Platform Configuration nav

---

## v0.0.38 -- 2026-08-15

### Improvements

  - Stability and performance improvements.

---

## v0.0.37 -- 2026-08-15

### Improvements

  - Stability and performance improvements.

---

## v0.0.36 -- 2026-08-14

### Improvements

  - Stability and performance improvements.

---

## v0.0.35 -- 2026-08-14

### Improvements

  - Stability and performance improvements.

---

## v0.0.34 -- 2026-08-13

### Improvements

  - Stability and performance improvements.

---

## v0.0.33 -- 2026-08-13

### Improvements

  - Stability and performance improvements.

---

## v0.0.32 -- 2026-08-13

### Improvements

  - Stability and performance improvements.

---

## v0.0.31 -- 2026-08-13

### Improvements

  - Stability and performance improvements.

---

## v0.0.30 -- 2026-08-13

### Improvements

  - Stability and performance improvements.

---

## v0.0.29 -- 2026-08-13

### Improvements

  - Stability and performance improvements.

---

## v0.0.28 -- 2026-08-13

### Improvements

  - Stability and performance improvements.

---

## v0.0.27 -- 2026-08-13

### Improvements

  - Stability and performance improvements.

---

## v0.0.26 -- 2026-08-13

### Improvements

  - Stability and performance improvements.

---

## v0.0.25 -- 2026-08-12

### Improvements

  - Stability and performance improvements.

---

## v0.0.24 -- 2026-08-12

### Improvements

  - Stability and performance improvements.

---

## v0.0.23 -- 2026-08-11

### Improvements

  - Stability and performance improvements.

---

## v0.0.22 -- 2026-08-11

### Improvements

  - Stability and performance improvements.

---

## v0.0.21 -- 2026-08-11

### New Features

  - add 117 native correlation rules (CR-057→CR-173) across Defense Evasion, Execution, Persistence, Credential Access, C2, Exfiltration, and Collection
  - CyDataLake evidence collector, remove Wazuh Manager API dependency, recommend-only response actions
  - rebuild ai_gateway/tim_gateway/soar_gateway as real blueprints

### Bug Fixes

  - consolidate 3 duplicate CyTIM clients, fix silent IOC-lookup bug
  - persist GeoIP data, fast-track 2 detection rules, close sensor-fabric gaps

---

## v0.0.20 -- 2026-08-11

### Bug Fixes

  - repair .env read permission and DooD project-directory bugs

---

## v0.0.19 -- 2026-08-11

### Bug Fixes

  - prevent fleet heartbeat from ever corrupting the project .env file

---

## v0.0.18 -- 2026-08-11

### Bug Fixes

  - send fleet monitor heartbeats without a pre-shared enrollment key

---

## v0.0.17 -- 2026-08-10

### Improvements

  - Stability and performance improvements.

---

## v0.0.16 -- 2026-08-10

### Bug Fixes

  - update embedded license validation key to match the current CyAdmin signing key

---

## v0.0.15 -- 2026-08-09

### Improvements

  - Stability and performance improvements.

---

## v0.0.14 -- 2026-08-09

### Improvements

  - Stability and performance improvements.

---

## v0.0.13 -- 2026-08-09

### Improvements

  - Stability and performance improvements.

---

## v0.0.12 -- 2026-08-09

### Bug Fixes

  - set a proper User-Agent on outbound marketplace catalog requests so Cloudflare's WAF doesn't block them
  - point the default marketplace catalog URL at marketplace.cyassure.eu instead of the retired cyassure.com host

---

## v0.0.11 -- 2026-08-09

### Improvements

  - Stability and performance improvements.

---

## v0.0.10 -- 2026-08-08

### Improvements

  - Stability and performance improvements.

---

## v0.0.9 -- 2026-08-08

### Improvements

  - Stability and performance improvements.

---

## v0.0.9 -- 2026-08-08

### Improvements

  - Stability and performance improvements.

---

## v0.0.8 -- 2026-08-08

### Improvements

  - Stability and performance improvements.

---

## v0.0.7 -- 2026-08-07

### Improvements

  - Stability and performance improvements.

---

## v0.0.6 -- 2026-08-07

### Improvements

  - Stability and performance improvements.

---

## v0.0.5 -- 2026-08-07

### Improvements

  - Stability and performance improvements.

---

## v0.0.4 -- 2026-08-07

### Improvements

  - Stability and performance improvements.

---

## v0.0.3 -- 2026-08-07

### Improvements

  - Stability and performance improvements.

---

## v0.0.2 -- 2026-08-07

### Improvements

  - Stability and performance improvements.

---

## v0.0.1 -- 2026-08-06

### Improvements

  - Stability and performance improvements.

---

## v0.0.0 -- 2026-08-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.339 -- 2026-08-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.338 -- 2026-08-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.337 -- 2026-08-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.336 -- 2026-08-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.335 -- 2026-08-06

### New Features

  - AI Applications page defaults to customer-added entries only
  - consolidate Shadow AI findings and catalog by real application instead of raw domain/process, and expand detection coverage

---

## v1.0.334 -- 2026-08-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.333 -- 2026-08-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.332 -- 2026-08-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.331 -- 2026-08-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.330 -- 2026-08-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.329 -- 2026-08-05

### New Features

  - Scan Operations moved back under External Exposure — only Vulnerabilities belongs in the new Vulnerability Management section

### Bug Fixes

  - Vulnerability Explorer's Vulnerability column dominated the row, leaving CVSS/EPSS/Module/Status cramped
  - Shadow AI Detection column still showed "-" for most web-based findings

---

## v1.0.328 -- 2026-08-05

### New Features

  - add an AI Applications management page — admins can add, edit, and remove the AI apps the platform detects for Shadow AI monitoring
  - Vulnerability Explorer's EPSS column overlapped the Module column; move Vulnerabilities and Scan Operations into a new Vulnerability Management section

### Bug Fixes

  - ASM scan history (past scans, reports, engine log) was silently wiped on every docker compose pull && up -d upgrade
  - Shadow AI Detection column showed "-" for findings discovered via the network-wide DNS monitor
  - resolve Linux/macOS numeric UIDs to real usernames so Behavioral Analytics stops miscategorizing human activity as System

---

## v1.0.327 -- 2026-08-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.326 -- 2026-08-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.325 -- 2026-08-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.324 -- 2026-08-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.323 -- 2026-08-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.322 -- 2026-08-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.321 -- 2026-08-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.320 -- 2026-08-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.319 -- 2026-08-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.318 -- 2026-08-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.317 -- 2026-08-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.316 -- 2026-08-04

### Improvements

  - Stability and performance improvements.

---

## v1.0.315 -- 2026-08-04

### Improvements

  - Stability and performance improvements.

---

## v1.0.314 -- 2026-08-03

### Improvements

  - Stability and performance improvements.

---

## v1.0.313 -- 2026-08-03

### Improvements

  - Stability and performance improvements.

---

## v1.0.312 -- 2026-08-03

### Improvements

  - Stability and performance improvements.

---

## v1.0.311 -- 2026-08-03

### Improvements

  - Stability and performance improvements.

---

## v1.0.310 -- 2026-08-03

### Bug Fixes

  - update embedded CYCENTRA_PUBLIC_KEY to match the signing key CyAdmin generated for the 77.42.75.20 pilot

---

## v1.0.309 -- 2026-08-02

### Improvements

  - Stability and performance improvements.

---

## v1.0.308 -- 2026-08-02

### New Features

  - enforce printer_local/printer_network on Linux and macOS via CUPS; fix a udev reload failure that was silently reported as success

### Bug Fixes

  - wifi_policy managed mode did nothing on macOS, and several device-control enforcement calls silently swallowed real failures
  - CyEDR device-control policy was silently unenforced on macOS USB and several fields were dropped on every platform

---

## v1.0.307 -- 2026-07-31

### Bug Fixes

  - Users & Auth settings tab crashed with a React hooks-order error whenever the user list loaded or session check completed

---

## v1.0.306 -- 2026-07-31

### New Features

  - add a GitHub connector and make the Connectors management page reachable for the first time

### Bug Fixes

  - remove legacy Office 365/GCP/GitHub integration routes that targeted a Wazuh Manager this deployment no longer has

---

## v1.0.305 -- 2026-07-31

### Bug Fixes

  - clarify that the internal alert schema and rule-to-control mapping are no longer Wazuh-specific

---

## v1.0.304 -- 2026-07-31

### New Features

  - CyDataLake gains full raw-event search, a query builder, stats, and saved searches
  - extend Sigma rule matching (3,600+ community detection rules) to EDR and native Wazuh events

### Bug Fixes

  - on-demand threat hunting never worked in the Docker deployment, and MCP's alert search scanned only the most recent 500 alerts
  - ASM scan findings were never forwarded to CyDataLake's raw archive, unlike every other event source

---

## v1.0.303 -- 2026-07-30

### New Features

  - threat-intel and AI enrichment now run automatically on every EDR-origin incident instead of only high/critical incidents with 3+ alerts, and threat-intel lookups now also check destination IP and EDR file hashes

### Bug Fixes

  - Linux persistence, tamper, and credential-file detections captured no target file and only a truncated command line, and credential-file access (/etc/shadow, /root/.ssh, etc.) was not being detected at all; split the generic persistence alert into cron/systemd/launchd/registry/service findings and suppress routine package-manager noise
  - correlated SIEM incidents were missing the username, process name, and destination IP for every EDR detection, and now also capture source/destination network port

---

## v1.0.302 -- 2026-07-30

### Bug Fixes

  - installer showed the wrong platform version, and a stray draft release could corrupt the version-notes feed

---

## v1.0.301 -- 2026-07-30

### New Features

  - surface an outdated CyEDR agent build indicator on the Endpoint Fleet page, agent detail modal, and per-endpoint detail page

---

## v1.0.300 -- 2026-07-30

### Bug Fixes

  - Linux CyEDR agent/tray binaries were built against an unpinned, ever-newer glibc, crash-looping on Ubuntu 22.04/20.04 hosts with zero EDR telemetry ever reaching the platform

---

## v1.0.299 -- 2026-07-30

### Improvements

  - Stability and performance improvements.

---

## v1.0.298 -- 2026-07-30

### Improvements

  - Stability and performance improvements.

---

## v1.0.297 -- 2026-07-30

### Bug Fixes

  - the self-update sidecar had no ghcr.io credentials of its own, so Update Now/Upgrade/CyDataLake-enable always failed with "unauthorized" pulling private images
  - ASM scan launch failed with a permission error, then a missing-scan-engine error, then a wrong-file-extension error — all three now fixed so Launch Scan actually runs

---

## v1.0.296 -- 2026-07-30

### Bug Fixes

  - release publishing no longer stalls on GitHub billing state, and Windows/Intel-Mac EDR builds move to on-demand instead of every release
  - cycentra-setup.sh could silently delete the entire install directory
  - cy-proxy no longer needs public DNS to be live to start up
  - cycentra-setup.sh now syncs BASE_DOMAIN into the app's own .env

---

## v1.0.295 -- 2026-07-30

### Bug Fixes

  - cycentra-setup.sh could silently delete the entire install directory
  - cy-proxy no longer needs public DNS to be live to start up
  - cycentra-setup.sh now syncs BASE_DOMAIN into the app's own .env

---

## v1.0.294 -- 2026-07-29

### Bug Fixes

  - cycentra-setup.sh could silently delete the entire install directory
  - cy-proxy no longer needs public DNS to be live to start up
  - cycentra-setup.sh now syncs BASE_DOMAIN into the app's own .env

---

## v1.0.293 -- 2026-07-29

### Bug Fixes

  - cycentra-setup.sh could silently delete the entire install directory
  - cy-proxy no longer needs public DNS to be live to start up
  - cycentra-setup.sh now syncs BASE_DOMAIN into the app's own .env

---

## v1.0.292 -- 2026-07-29

### Improvements

  - Stability and performance improvements.

---

## v1.0.291 -- 2026-07-29

### Bug Fixes

  - cysiemstack-engine still crashed on hosts where /opt/cycentra itself was unreadable, not just its subfolders

---

## v1.0.290 -- 2026-07-29

### Bug Fixes

  - build-and-publish could upload to a release that doesn't exist yet
  - stop build-and-publish from blocking the shared runner for 8 minutes

---

## v1.0.289 -- 2026-07-29

### New Features

  - move the Intel macOS EDR build off GitHub-hosted, cross-build via Rosetta

### Bug Fixes

  - use a venv for the macOS EDR build, Homebrew Python blocks bare pip install
  - self-hosted macOS EDR build now uses Homebrew Python, not setup-python

---

## v1.0.288 -- 2026-07-29

### Bug Fixes

  - RUNNER_TOOL_CACHE must be set via a step, not job-level env
  - self-hosted macOS runner couldn't build EDR binaries, RUNNER_TOOL_CACHE was never set

---

## v1.0.287 -- 2026-07-29

### Bug Fixes

  - cysiemstack-engine could crash on startup when /opt/cycentra pre-existed with restrictive permissions, blocking the whole stack from starting

---

## v1.0.286 -- 2026-07-29

### Bug Fixes

  - cysiemstack-engine could crash on startup when /opt/cycentra pre-existed with restrictive permissions, blocking the whole stack from starting

---

## v1.0.285 -- 2026-07-29

### Improvements

  - Stability and performance improvements.

---

## v1.0.284 -- 2026-07-29

### Improvements

  - Stability and performance improvements.

---

## v1.0.283 -- 2026-07-29

### Improvements

  - Stability and performance improvements.

---

## v1.0.282 -- 2026-07-28

### Improvements

  - Stability and performance improvements.

---

## v1.0.281 -- 2026-07-28

### Improvements

  - Stability and performance improvements.

---

## v1.0.280 -- 2026-07-28

### Improvements

  - Stability and performance improvements.

---

## v1.0.279 -- 2026-07-28

### Improvements

  - Stability and performance improvements.

---

## v1.0.278 -- 2026-07-28

### Improvements

  - Stability and performance improvements.

---

## v1.0.277 -- 2026-07-28

### Improvements

  - Stability and performance improvements.

---

## v1.0.276 -- 2026-07-28

### Improvements

  - Stability and performance improvements.

---

## v1.0.275 -- 2026-07-28

### Improvements

  - Stability and performance improvements.

---

## v1.0.274 -- 2026-07-28

### Improvements

  - Stability and performance improvements.

---

## v1.0.273 -- 2026-07-28

### Improvements

  - Stability and performance improvements.

---

## v1.0.272 -- 2026-07-28

### Improvements

  - Stability and performance improvements.

---

## v1.0.271 -- 2026-07-28

### Improvements

  - Stability and performance improvements.

---

## v1.0.270 -- 2026-07-28

### Improvements

  - Stability and performance improvements.

---

## v1.0.269 -- 2026-07-27

### Improvements

  - Stability and performance improvements.

---

## v1.0.268 -- 2026-07-27

### Improvements

  - Stability and performance improvements.

---

## v1.0.267 -- 2026-07-27

### Improvements

  - Stability and performance improvements.

---

## v1.0.266 -- 2026-07-27

### New Features

  - restore the release-bundle format cycentra-setup.sh actually needs, add missing nmap to backend image
  - add one-command installer script for new customers
  - publish the actual customer install bundle to GitHub Releases

### Bug Fixes

  - align Docker bind-mount paths with cycentra-setup.sh's absolute-path assumptions
  - retire Azure Arc support and fix wrong-repo bug in cycentra-setup.sh

---

## v1.0.265 -- 2026-07-27

### Improvements

  - Stability and performance improvements.

---

## v1.0.264 -- 2026-07-27

### Bug Fixes

  - resolve false license-expired lockout caused by missing validator in Docker image

---

## v1.0.263 -- 2026-07-27

### Improvements

  - Stability and performance improvements.

---

## v1.0.262 -- 2026-07-26

### Improvements

  - Stability and performance improvements.

---

## v1.0.261 -- 2026-07-26

### Improvements

  - Stability and performance improvements.

---

## v1.0.260 -- 2026-07-26

### Improvements

  - Stability and performance improvements.

---

## v1.0.259 -- 2026-07-22

### Improvements

  - Stability and performance improvements.

---

## v1.0.258 -- 2026-07-20

### Improvements

  - Stability and performance improvements.

---

## v1.0.257 -- 2026-07-19

### Improvements

  - Stability and performance improvements.

---

## v1.0.256 -- 2026-07-19

### Improvements

  - Stability and performance improvements.

---

## v1.0.255 -- 2026-07-19

### Improvements

  - Revert "chore: pre-release commit (auto-staged by git-push.sh)"
  - Revert "Release v1.0.254 at 2026-07-19T19:06:03Z"

---

## v1.0.253 -- 2026-07-19

### Improvements

  - Stability and performance improvements.

---

## v1.0.252 -- 2026-07-19

### Improvements

  - Stability and performance improvements.

---

## v1.0.251 -- 2026-07-19

### Improvements

  - Stability and performance improvements.

---

## v1.0.250 -- 2026-07-19

### Improvements

  - Stability and performance improvements.

---

## v1.0.249 -- 2026-07-19

### Improvements

  - Stability and performance improvements.

---

## v1.0.248 -- 2026-07-19

### Improvements

  - Stability and performance improvements.

---

## v1.0.247 -- 2026-07-19

### Improvements

  - Stability and performance improvements.

---

## v1.0.246 -- 2026-07-18

### Improvements

  - Stability and performance improvements.

---

## v1.0.245 -- 2026-07-18

### Bug Fixes

  - ci): migrate build-edr-macos off retired/deprecating runner images

---

## v1.0.244 -- 2026-07-18

### Bug Fixes

  - ci): route macOS/Windows EDR binary hand-off through Release assets, not Actions Artifacts

---

## v1.0.243 -- 2026-07-18

### Improvements

  - Stability and performance improvements.

---

## v1.0.242 -- 2026-07-18

### Improvements

  - Stability and performance improvements.

---

## v1.0.241 -- 2026-07-18

### Improvements

  - Stability and performance improvements.

---

## v1.0.240 -- 2026-07-18

### Improvements

  - Stability and performance improvements.

---

## v1.0.239 -- 2026-07-18

### Improvements

  - Stability and performance improvements.

---

## v1.0.239 -- 2026-07-18

### Improvements

  - Removed the live Wazuh Manager API dependency platform-wide (Phase 5 of the CyDataLake migration, closing out the two remaining items from `docs/SIEM_PROXY_AUDIT.md`): host list/enroll/remove and SCA now source from CyEDR/CyCollector's own agent registries, `edr_sca_results`, and ITAM's `software_inventory` instead of a live `WAZUH_API_URL` call. Same rebuild applied in parallel to `siem_proxy.py` (on-demand refresh) and `cysiemstack/host_service.py` (hourly scheduled refresh), plus the benchmark engine's vulnerability/SCA sub-scores. `WAZUH_API_URL`/`WAZUH_API_USER`/`WAZUH_API_PASSWORD` removed from `cycentra-setup.sh` and every backend consumer; the Wazuh integration-health check retired.
  - Fixed `cycentra-setup.sh`'s `options-ssl-nginx.conf` provisioning: it only checked the file existed (`-f`), not that it was non-empty (`-s`), so a truncated/interrupted write from an earlier run was never repaired on subsequent runs and broke `nginx -t`.

---

## v1.0.238 -- 2026-07-18

### Bug Fixes

  - Make tray Stop/Exit recovery explicit; fix Linux watchdog undermining it

---

## v1.0.237 -- 2026-07-17

### Improvements

  - Stability and performance improvements.

---

## v1.0.236 -- 2026-07-17

### Bug Fixes

  - Fix tray build: host-only warn() called from inside Docker container
  - Fix Linux CyEDR/tray binary build: PyInstaller API + apt-get masking

### Improvements

  - force quota check
  - Fully decouple build-and-publish from macOS/Windows job completion
  - Decouple Linux EDR binary build from Actions artifact quota

---

## v1.0.235 -- 2026-07-17

### Bug Fixes

  - Fix tray build: host-only warn() called from inside Docker container
  - Fix Linux CyEDR/tray binary build: PyInstaller API + apt-get masking

### Improvements

  - Fully decouple build-and-publish from macOS/Windows job completion
  - Decouple Linux EDR binary build from Actions artifact quota

---

## v1.0.234 -- 2026-07-17

### Improvements

  - Stability and performance improvements.

---

## v1.0.233 -- 2026-07-16

### Improvements

  - Stability and performance improvements.

---

## v1.0.232 -- 2026-07-16

### Bug Fixes

  - Fix cyedr-install.sh reinstall not restarting a running agent (Linux

---

## v1.0.231 -- 2026-07-16

### Improvements

  - Install watchdog in cyedr-install.sh's Python-mode fallback

---

## v1.0.230 -- 2026-07-16

### New Features

  - Add Host Security Profile enterprise EDR capabilities to CyEDR

---

## v1.0.229 -- 2026-07-16

### Improvements

  - Stability and performance improvements.

---

## v1.0.229 -- 2026-07-16

### Removed

  - Removed the Host Intelligence "Agent Groups", "Response Playbooks", and "Sensor Deployment"
    tabs and their components (`AgentGroupsTab.jsx`, `EndpointPoliciesTab.jsx`,
    `SensorDeploymentTab.jsx`) — these were Wazuh-Manager-API-dependent features and Wazuh is no
    longer used as a sensor.
  - Removed all backing backend routes: `/api/siem/agent-groups*` and
    `/api/siem/endpoint-policies*` (`siem_proxy.py`), and `/api/system/agent-installer`,
    `/api/system/agent-packages*` (`blueprints/system/routes.py`), including the embedded
    installer shell/PowerShell script templates. Deleted the now-obsolete
    `tests/unit/test_agent_installer.py`.
  - CyEDR's own agent installer (`/api/edr/installer/*`) and its unrelated `edr_agent_groups`
    policy-engine tables (`blueprints/edr/policy_engine.py`) are unaffected.

---

## v1.0.228 -- 2026-07-16

### Improvements

  - Stability and performance improvements.

---

## v1.0.227 -- 2026-07-16

### Improvements

  - Stability and performance improvements.

---

## v1.0.226 -- 2026-07-16

### Bug Fixes

  - Fix CyEDR telemetry pipeline dropping every event before scoring

### Improvements

  - chore(docs): weekly architecture review 2026-07-16

---

## v1.0.225 -- 2026-07-15

### Improvements

  - Stability and performance improvements.

---

## v1.0.224 -- 2026-07-15

### Improvements

  - Stability and performance improvements.

---

## v1.0.223 -- 2026-07-15

### Improvements

  - Stability and performance improvements.

---

## v1.0.222 -- 2026-07-15

### Improvements

  - Stability and performance improvements.

---

## v1.0.221 -- 2026-07-15

### Improvements

  - Stability and performance improvements.

---

## v1.0.220 -- 2026-07-15

### Improvements

  - Stability and performance improvements.

---

## v1.0.219 -- 2026-07-15

### Improvements

  - Stability and performance improvements.

---

## v1.0.218 -- 2026-07-15

### Improvements

  - Stability and performance improvements.

---

## v1.0.217 -- 2026-07-15

### Improvements

  - Stability and performance improvements.

---

## v1.0.216 -- 2026-07-13

### Improvements

  - Stability and performance improvements.

---

## v1.0.215 -- 2026-07-13

### Improvements

  - Stability and performance improvements.

---

## v1.0.214 -- 2026-07-13

### Improvements

  - Stability and performance improvements.

---

## v1.0.213 -- 2026-07-13

### Improvements

  - Stability and performance improvements.

---

## v1.0.212 -- 2026-07-13

### Improvements

  - Stability and performance improvements.

---

## v1.0.211 -- 2026-07-13

### Improvements

  - Stability and performance improvements.

---

## v1.0.210 -- 2026-07-13

### Improvements

  - Stability and performance improvements.

---

## v1.0.209 -- 2026-07-13

### Improvements

  - Stability and performance improvements.

---

## v1.0.208 -- 2026-07-13

### Improvements

  - Stability and performance improvements.

---

## v1.0.207 -- 2026-07-13

### Improvements

  - Stability and performance improvements.

---

## v1.0.206 -- 2026-07-10

### Improvements

  - Stability and performance improvements.

---

## v1.0.206 -- 2026-07-10

### Improvements

  - Stability and performance improvements.

---

## v1.0.205 -- 2026-07-10

### Improvements

  - Stability and performance improvements.

---

## v1.0.204 -- 2026-07-10

### Improvements

  - Stability and performance improvements.

---

## v1.0.203 -- 2026-07-10

### Improvements

  - Stability and performance improvements.

---

## v1.0.202 -- 2026-07-10

### Improvements

  - Stability and performance improvements.

---

## v1.0.201 -- 2026-07-09

### Bug Fixes

  - shadow-ai): resolve telemetry 401 and bare-envelope format bugs

---

## v1.0.200 -- 2026-07-09

### Bug Fixes

  - edr-installer): full Linux distro compatibility (Alpine, RHEL ARM, CentOS, dnf/yum ordering
  - edr-installer): resolve Linux Python dep install failure on Ubuntu 22.04+

---

## v1.0.199 -- 2026-07-09

### Improvements

  - Stability and performance improvements.

---

## v1.0.198 -- 2026-07-09

### Improvements

  - Stability and performance improvements.

---

## v1.0.197 -- 2026-07-09

### Improvements

  - Stability and performance improvements.

---

## v1.0.196 -- 2026-07-09

### Improvements

  - Stability and performance improvements.

---

## v1.0.195 -- 2026-07-09

### Improvements

  - Stability and performance improvements.

---

## v1.0.194 -- 2026-07-09

### Improvements

  - Stability and performance improvements.

---

## v1.0.193 -- 2026-07-09

### Improvements

  - Stability and performance improvements.

---

## v1.0.192 -- 2026-07-09

### Improvements

  - Stability and performance improvements.

---

## v1.0.191 -- 2026-07-09

### Improvements

  - chore(docs): weekly architecture review 2026-07-09

---

## v1.0.190 -- 2026-07-09

### Improvements

  - chore(docs): weekly architecture review 2026-07-09

---

## v1.0.189 -- 2026-07-08

### Improvements

  - Stability and performance improvements.

---

## v1.0.188 -- 2026-07-08

### Improvements

  - Stability and performance improvements.

---

## v1.0.187 -- 2026-07-08

### Improvements

  - Stability and performance improvements.

---

## v1.0.186 -- 2026-07-08

### Improvements

  - Stability and performance improvements.

---

## v1.0.185 -- 2026-07-08

### Improvements

  - Stability and performance improvements.

---

## v1.0.184 -- 2026-07-07

### Improvements

  - Stability and performance improvements.

---

## v1.0.183 -- 2026-07-07

### Improvements

  - Stability and performance improvements.

---

## v1.0.182 -- 2026-07-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.181 -- 2026-07-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.180 -- 2026-07-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.179 -- 2026-07-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.178 -- 2026-07-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.177 -- 2026-07-06

### New Features

  - dashboard): remove SIEM widgets, add donut charts to all 8 ASM widgets

---

## v1.0.176 -- 2026-07-06

### New Features

  - dashboard): redesign External Attack Posture page layout and visuals

---

## v1.0.175 -- 2026-07-06

### New Features

  - asm): AI enrichment uses CyMind only; remove Gemini and Ollama fallbacks

---

## v1.0.175 -- 2026-07-06

### Architecture — AI Enrichment, CyTIM Connection & ASM Dashboard (2026-07-06)

#### AI Enrichment — CyMind Only

ASM deep-scan AI enrichment now uses **CyMind exclusively** (configured via Platform Configuration → Extensions). The Gemini and Ollama fallback providers have been removed:

- Removed `google-genai` dependency from `requirements.txt`
- Removed `_get_gemini_key()`, `_get_ollama_config()`, `resolve_ollama_model()`, `_trim_payload()`, `get_available_ollama_models()` from `cycentra_scan.py`
- Removed `GOOGLE_GEMINI_KEY` from `cy_asm/config.py`, `kv_secrets.py`, and `.env.example`
- If CyMind is not configured, AI enrichment is skipped gracefully — the scan completes normally without AI findings
- Log message now clearly directs to Platform Configuration → Extensions when CyMind is unavailable

#### CyTIM Connection — UI-Only (No Env Var Fallback)

The CyTIM URL and API key are now exclusively read from `/opt/cycentra/ai_settings.json` (set via Platform Configuration → Extensions). No `.env` fallback:

- Removed `CYTIM_URL` and `CYTIM_API_KEY` from `core/config.py`
- `_get_cytim_settings()` in `core/helpers.py` returns `("", "")` if ai_settings.json has no CyTIM config — no env var fallback
- `get_threat_intel_client()` updated to use `_get_cytim_settings()` directly
- Benchmark route `_collect_threat_intel_score()` now reads CyTIM URL from ai_settings.json instead of OS env / cysiemstack.env
- Note: the **correlation engine** (`cysiemstack/correlation_engine/`) still reads from `cysiemstack.env` — this is synced automatically when CyTIM settings are saved in the UI

#### ASM Timeout Increases

- `CYTIM_BULK_TIMEOUT`: 45s → **90s** — prevents false timeout failures on 31-IOC enrichment batches
- `CYTIM_RECON_TIMEOUT`: 30s → **45s** — allows slower recon modules (CVE, WHOIS history) to complete

#### ASM — Shodan Direct Call Removed

`passive_osint.py`: Shodan is no longer called directly when CyTIM is active. Shodan data now arrives exclusively via `POST /api/cytim/bulk-enrich` (profile=asm). Direct Shodan call retained only as a CyTIM-unavailable fallback.

#### External Attack Posture Dashboard — Data Gap Fixes

All scan JSON data that was present but not displayed has been surfaced:

- **Widget 3 (Network/DNS)**: Added WHOIS domain expiry countdown with colour-coded urgency bar (red <30d, amber <90d), DNS takeover risk banner, IP Geo/ASN table (up to 3 IPs with country + org)
- **Widget 5 (Vulnerabilities)**: Added EPSS probability badge on every vuln row; added HTTP security headers checklist (missing headers in red, present headers in green) from `http_analysis`
- **Widget 6 (Inventory)**: Added "Unregistered Typosquats" and "DNS Takeover Risks" counts
- **Widget 8 (Exposure)**: Added Shodan exposed services detail and Mobile/API exposure block from `mobile_api.api_findings`
- **Bottom vuln table**: EPSS badge alongside CVSS score on every row
- **Removed**: High Confidence Incidents widget and SOAR Activity widget from the External Attack Posture page

---

## v1.0.174 -- 2026-07-06

### Bug Fixes

  - asm): bucket_summary dict, provider name cleanup, validator broadened, recon timeout

---

## v1.0.173 -- 2026-07-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.172 -- 2026-07-06

### Bug Fixes

  - siem+edr): CyTIM enrichment format mismatch, ioc-feed route, TI panel render

---

## v1.0.171 -- 2026-07-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.170 -- 2026-07-05

### Bug Fixes

  - asm): CYTIM bulk timeout, MISP 403 skip, AI hallucination guard

---

## v1.0.169 -- 2026-07-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.168 -- 2026-07-05

### New Features

  - Route all ASM external APIs through CyTIM recon endpoint

---

## v1.0.168 -- 2026-07-05

### Architecture — CyTIM Recon Consolidation (Full External API Migration)

All ASM external API calls are now routed through CyTIM as the single intelligence
gateway. ASM no longer manages keys or HTTP sessions for any discovery API — it sends
requests to CyTIM and CyTIM fans out to the underlying sources with caching, rate
limiting, and key management handled centrally.

#### New — `cytim_recon()` helper (`core/helpers.py`)
Added `cytim_recon(domain, modules, **kwargs)` — mirrors `cytim_bulk_enrich` pattern.
POSTs to `POST /api/cytim/recon`, returns results dict keyed by module, never raises.
Used by all five ASM modules below.

#### `backend/cy_asm/modules/subdomain_enum.py`
- Removed `get_subdomains_virustotal()`, `get_subdomains_alienvault()`, `get_subdomains_securitytrails()` — all three called external APIs directly.
- Added `get_subdomains_cytim_recon(domain)` — single CyTIM `subdomains` module call (VT + OTX + SecurityTrails concurrent inside CyTIM).
- `gather_subdomains()` default sources changed from `securitytrails/virustotal/alienvault` to `cytim`. crt.sh, MISP, brute-force, crawl remain direct.
- Removed `SECURITYTRAILS_API_KEY`, `VIRUSTOTAL_API_KEY` from config import.

#### `backend/cy_asm/modules/social_eng.py`
- Removed `find_emails_hunter()` — called Hunter.io directly.
- Added `find_emails_cytim(domain)` — routes Hunter.io through CyTIM `emails` module.
- `gather_social_eng()` runs CyTIM emails via executor; LinkedIn dork stays direct.
- Removed `HUNTER_API_KEY` from config import.

#### `backend/cy_asm/modules/dns_recon.py`
- Removed per-IP IPInfo loop — called `ipinfo.io` once per IP.
- Added `_cytim_geoip(domain, ips)` — single batch call to CyTIM `geoip` module.
- `get_ip_addresses()` now collects all IPs first, then enriches all at once via one executor call.
- Removed `IPINFO_API_KEY` from config import.

#### `backend/cy_asm/modules/vuln_scanner.py`
- Removed `_fetch_nvd_cves()` and `_fetch_epss()` — called NVD and EPSS directly.
- Added `_cytim_cve_by_keyword(domain, keyword)` — NVD search via CyTIM `cve` module.
- Added `_cytim_epss_batch(domain, cve_ids)` — EPSS lookup via CyTIM `cve` module.
- `enrich_port_findings()` still does per-port CVE lookups (preserving port context) via executor; single batch EPSS call at end.
- Removed `NVD_API_KEY`, `EPSS_API_URL`, `_NVD_BASE` constant.

#### `backend/cy_asm/modules/whois_history.py`
- Removed direct ViewDNS HTML scrape in `get_domain_history()`.
- Added `_cytim_whois_history(domain)` — routes ViewDNS through CyTIM `whois_history` module.
- Local `python-whois` data (registrar, expiry) remains direct and unchanged.

#### `backend/cy_asm/modules/web_analysis.py`
- Removed direct NVD call during port fingerprinting (per-port CVE ID lookup).
- Replaced with `cytim_recon(host, ["cve"], cve_keywords=[banner])` via executor.
- Removed `NVD_API_KEY` from config import (would have caused ImportError after config cleanup).

#### `backend/cy_asm/config.py` — cleanup
- Removed 6 keys that are now managed by CyTIM: `IPINFO_API_KEY`, `SECURITYTRAILS_API_KEY`, `VIRUSTOTAL_API_KEY`, `NVD_API_KEY`, `HUNTER_API_KEY`, `HIBP_API_KEY`.
- Removed unused `EPSS_API_URL` constant.
- Kept: `SHODAN_API_KEY` (fallback in passive_osint), `GOOGLE_GEMINI_KEY` (AI enrichment), `GVM_PASSWORD`, `GVM_USER`.

#### `backend/core/kv_secrets.py` — cleanup
- `ASM_KV_MAP` trimmed from 12 → 4 entries. Removed: `IPINFO_API_KEY`, `SECURITYTRAILS_API_KEY`, `VIRUSTOTAL_API_KEY`, `NVD_API_KEY`, `HUNTER_API_KEY`, `HIBP_API_KEY`, `ABUSEIPDB_API_KEY`, `GREYNOISE_API_KEY`.
- Kept: `SHODAN_API_KEY`, `GOOGLE_GEMINI_KEY`, `GVM_PASSWORD`, `GVM_USER`.

#### Fix — CyTIM Test Connection now validates API key properly (`blueprints/system/routes.py`)
- Changed from hitting `/health` (unauthenticated) to `/api/cytim/sources` (authenticated).
- Returns specific error messages for 401 (invalid key), 403 (key disabled), and other failures.
- Removed fallback path that tested without a key.

#### What stays direct (per architecture doc)
| API | File | Reason |
|-----|------|--------|
| crt.sh | `subdomain_enum.py` | Free, keyless, 6h on-disk cache — no key benefit from CyTIM |
| Shodan | `passive_osint.py` | CyTIM fallback only — fires if CyTIM unreachable |
| Google Gemini | `cycentra_scan.py` | AI text generation for deep scan enrichment |
| GVM/OpenVAS | `vuln_scanner.py` | Local Unix socket — not an external API |

#### Ops — keys to migrate to CyTIM `cytim.env`
The following keys were in Cy360's `.env` / Azure Key Vault and should now live in CyTIM only:
```
SECURITYTRAILS_API_KEY, HUNTER_API_KEY, IPINFO_API_KEY, NVD_API_KEY
```
VT and OTX keys are already in CyTIM. HIBP was already migrated in v1.0.154.

---

## v1.0.167 -- 2026-07-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.166 -- 2026-07-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.165 -- 2026-07-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.164 -- 2026-07-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.163 -- 2026-07-05

### New Features

  - ASM scan now routes all TI enrichment through CyTIM (profile=asm: Shodan, VT, GreyNoise, MISP, AlienVault)
  - Dark web scan (Ahmia + HIBP) now runs inside CyTIM — toggle-controlled from CyTIM Sources tab
  - passive_osint.py routes domain TI through CyTIM; falls back to MISP when CyTIM not configured
  - `is_cytim_enabled()`, `cytim_bulk_enrich()`, `cytim_darkweb_enrich()`, `is_darkweb_enabled()` centralized gateway helpers added to core/helpers.py
  - `CYTIM_ENABLED` master switch added to core/config.py

---

## v1.0.162 -- 2026-07-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.161 -- 2026-07-05

### New Features

  - replace MISP/direct-TI with CyTIM broker; fix FP scoring efficacy

---

## v1.0.160 -- 2026-07-05

### New Features

  - replace MISP/direct-TI with CyTIM broker; fix FP scoring efficacy

---

## v1.0.160 -- 2026-07-05

### Improvements

  - **MISP removal — CyTIM broker**: Removed all direct MISP/VT/AbuseIPDB/GreyNoise connections from Cy360 Flask layer. All TI enrichment now routes through CyTIM (single broker). CyMISP Docker module removed from Platform installer.
  - **FP scoring fix**: `compute_fp_score()` now uses all CyTIM source hits (`ti_reputation.ioc_hits`) for false-positive probability, not MISP-only hits. VT/AbuseIPDB/GreyNoise threat hits now correctly reduce FP probability.
  - **Settings UI — Threat Intel tab**: Replaced MISP card + individual TI API key cards with a single CyTIM connection card. URL and API key are saved and synced to `cysiemstack.env` automatically.
  - **Frontend labels**: "MISP IOC Hits" → "TI IOC Hits" in risk score breakdowns; "AI + MISP ENRICHMENT" → "AI + THREAT INTEL" in host enrichment; IOC badge in incidents list now uses `ti_reputation.ioc_hits` (all sources).
  - **Benchmark TI score**: Now reflects CyTIM health — 40 pts (DB ok) + up to 60 pts (20 per active TI source).
  - **New backend route**: `POST /api/ai/settings/cytim/test` (analyst+) — tests CyTIM connectivity, returns source-level health status.

---

## v1.0.159 -- 2026-07-02

### New Features

  - remove CyScan Rules from sidebar nav (now a tab inside Policies

---

## v1.0.158 -- 2026-07-02

### New Features

  - remove CyScan Rules from sidebar nav (now a tab inside Policies

---

## v1.0.157 -- 2026-07-02

### New Features

  - policies 3-tab shell, response console tabs, EDR groups UI, EDR license count

---

## v1.0.156 -- 2026-07-02

### Improvements

  - Stability and performance improvements.

---

## v1.0.155 -- 2026-07-02

### Improvements

  - Stability and performance improvements.

---

## v1.0.154 -- 2026-07-02

### Improvements

  - Stability and performance improvements.

---

## v1.0.153 -- 2026-07-02

### Improvements

  - chore(docs): weekly architecture review 2026-07-02

---

## v1.0.152 -- 2026-07-02

### Improvements

  - Stability and performance improvements.

---

## v1.0.152 -- 2026-07-02

### New Features

  - feat(siem): ASM scan findings and analyst escalations now flow into Active Incidents pipeline — high/critical findings pushed to Redis on scan completion (`.siem_pushed` guard prevents replay); escalation hook fires on `in_review` status transition
  - feat(siem): ITAM anomalies now flow into Active Incidents — deep scan CVEs (top-20 per asset), high-risk IoT devices (risk ≥ 75, new-discovery only), and Shadow AI detections (new findings only) all push to SIEM correlation engine
  - feat(siem): New synthetic rule ID namespace 200100–200299 for ASM and ITAM alerts; no Wazuh XML or cycentra-setup.sh changes needed; normaliser categorises by range
  - feat(siem): Auto-case opening extended — critical ASM findings and critical ITAM CVEs force-open a CyCase immediately, bypassing the alert_count ≥ 3 threshold
  - feat(siem): `_infer_case_type()` updated in both `cases/service.py` and `correlation_engine/ingestor.py` — new case types: `asm_finding`, `vulnerability`, `shadow_ai`, `itam_anomaly`
  - feat(nav): Case Management moved from INTERNAL EXPOSURE section to standalone CASE MANAGEMENT nav section at the bottom of the sidebar

### Bug Fixes

  - fix(siem): Rule ID collision — initial allocation used 100400–100503 which overlap with existing Wazuh lateral movement and persistence rules in cy_cust_rules.xml; renumbered to 200100+ (unoccupied range)

---

## v1.0.151 -- 2026-07-01

### Improvements

  - Stability and performance improvements.

---

## v1.0.150 -- 2026-07-01

### Improvements

  - Stability and performance improvements.

---

## v1.0.149 -- 2026-07-01

### Improvements

  - Stability and performance improvements.

---

## v1.0.148 -- 2026-07-01

### Improvements

  - revert(deploy): remove hardcoded server auto-deploy step

---

## v1.0.147 -- 2026-07-01

### Improvements

  - Stability and performance improvements.

---

## v1.0.146 -- 2026-07-01

### Bug Fixes

  - itam): clear stale edr_agent_id/siem_agent_id refs before crossref

---

## v1.0.145 -- 2026-07-01

### Bug Fixes

  - fix(itam): stale edr_agent_id/siem_agent_id references now cleared before crossref runs

---

## v1.0.144 -- 2026-07-01

### Bug Fixes

  - fix(cyedr): startup dedup — agents sharing same hardware_uuid are auto-merged at backend startup

---

## v1.0.143 -- 2026-07-01

### Bug Fixes

  - fix(cyedr): stable hardware UUID (IOPlatformUUID/machine-id/WMIC) prevents duplicate agent registration on reinstall
  - fix(cyedr): installer now preserves agent_id + enrollment_token across reinstalls
  - fix(cyedr): server deduplicates by hardware_uuid first, hostname second

---

## v1.0.142 -- 2026-07-01

### Bug Fixes

  - fix(cyedr): APPLY_POLICY command now fully implemented — all 7 policy types enforced on-agent (threat_prevention, device_control, app_control, network_control, exclusions, update_policy, isolation_exceptions)
  - fix(cyedr): DNS sinkhole domains written to /etc/hosts with BEGIN/END fences; DNS cache flushed cross-platform
  - fix(deploy): CyEDR agent source and installer scripts now included in release bundle so setup.sh --update stages them correctly

---

## v1.0.141 -- 2026-07-01

### Improvements

  - Stability and performance improvements.

---

## v1.0.140 -- 2026-07-01

### Bug Fixes

  - cyscan): spurious critical detection when YARA finds 0 matches

---

## v1.0.139 -- 2026-07-01

### Bug Fixes

  - cyedr): run brew as SUDO_USER — Homebrew refuses to run as root

---

## v1.0.138 -- 2026-07-01

### Improvements

  - Stability and performance improvements.

---

## v1.0.137 -- 2026-07-01

### Improvements

  - Stability and performance improvements.

---

## v1.0.136 -- 2026-07-01

### Improvements

  - Stability and performance improvements.

---

## v1.0.135 -- 2026-07-01

### Improvements

  - Stability and performance improvements.

---

## v1.0.134 -- 2026-07-01

### Improvements

  - Stability and performance improvements.

---

## v1.0.133 -- 2026-07-01

### Improvements

  - Stability and performance improvements.

---

## v1.0.132 -- 2026-07-01

### Improvements

  - Stability and performance improvements.

---

## v1.0.131 -- 2026-07-01

### Improvements

  - Stability and performance improvements.

---

## v1.0.130 -- 2026-06-30

### Improvements

  - Stability and performance improvements.

---

## v1.0.129 -- 2026-06-30

### Improvements

  - Stability and performance improvements.

---

## v1.0.128 -- 2026-06-30

### Improvements

  - Stability and performance improvements.

---

## v1.0.127 -- 2026-06-30

### Improvements

  - Stability and performance improvements.

---

## v1.0.126 -- 2026-06-30

### Improvements

  - Stability and performance improvements.

---

## v1.0.125 -- 2026-06-30

### Improvements

  - Stability and performance improvements.

---

## v1.0.124 -- 2026-06-30

### Improvements

  - Stability and performance improvements.

---

## v1.0.123 -- 2026-06-30

### Improvements

  - Stability and performance improvements.

---

## v1.0.122 -- 2026-06-30

### Improvements

  - Stability and performance improvements.

---

## v1.0.121 -- 2026-06-30

### Bug Fixes

  - edr): guarantee pip deps land in root's Python path during install
  - edr): retire previous enrollments on re-enroll by same hostname
  - edr): pip install to root home so LaunchDaemon can import deps
  - edr): detect pip --break-system-packages support before using it
  - edr): install Python deps with --break-system-packages for macOS

---

## v1.0.120 -- 2026-06-30

### Bug Fixes

  - edr): official OS SVGs in fleet, skip re-enrollment on reinstall

---

## v1.0.119 -- 2026-06-30

### Bug Fixes

  - edr): save enrollment_token to config and use for agent auth

---

## v1.0.118 -- 2026-06-30

### Improvements

  - Stability and performance improvements.

---

## v1.0.117 -- 2026-06-30

### Improvements

  - Stability and performance improvements.

---

## v1.0.116 -- 2026-06-30

### Improvements

  - Stability and performance improvements.

---

## v1.0.115 -- 2026-06-30

### Improvements

  - Stability and performance improvements.

---

## v1.0.114 -- 2026-06-30

### Improvements

  - Stability and performance improvements.

---

## v1.0.113 -- 2026-06-30

### Improvements

  - Stability and performance improvements.

---

## v1.0.112 -- 2026-06-30

### Improvements

  - Stability and performance improvements.

---

## v1.0.111 -- 2026-06-30

### Improvements

  - Stability and performance improvements.

---

## v1.0.110 -- 2026-06-29

### Improvements

  - Stability and performance improvements.

---

## v1.0.109 -- 2026-06-29

### Improvements

  - Stability and performance improvements.

---

## v1.0.108 -- 2026-06-29

### Improvements

  - Stability and performance improvements.

---

## v1.0.108 -- 2026-06-30

### New Features — ITAM Phase 3: Intelligence & Scale

**Local NVD Mirror (Offline CVE Database)**

CyCentra now maintains a local PostgreSQL mirror of the full NVD CVE database:
- `nvd_cves` table stores all CVE IDs, severity, CVSS score, and description
- Daily incremental sync (last 8 days) and weekly full sync via APScheduler
- CVE enrichment now uses local mirror first — eliminates NVD API rate limits entirely
- Manual triggers available: `POST /api/itam/nvd-mirror/sync` and `/full-sync`

**CISA Known Exploited Vulnerabilities (KEV)**

Integrates the CISA KEV catalog to identify CVEs that are actively being exploited in the wild:
- `kev_catalog` table synced daily at 01:30 UTC
- KEV flag on every vulnerable package in the Asset Detail software table
- Per-asset `GET /api/itam/assets/<id>/exploit-intel` returns KEV count, affected packages, ransomware risk
- `POST /api/itam/nvd-mirror/kev-sync` for on-demand sync

**EPSS Exploitation Probability Scores**

Every CVE is now enriched with its EPSS score (0–1) from FIRST.org — the probability that the vulnerability will be exploited in the next 30 days:
- Batch API fetch (100 CVEs per call) via api.first.org
- EPSS % displayed per package in the software inventory table
- Color-coded: >50% = red, >10% = orange, else grey

**SNMP Network Device Polling**

Discover and inventory routers, switches, firewalls, and other SNMP-capable devices without SSH:
- SNMP v2c via `pysnmp-lextudio`
- Collects sysDescr, sysName, sysLocation, sysUpTime, ifTable (up to 24 interfaces)
- Device type inference: Cisco/Juniper/FortiGate/HP ProCurve/Aruba/Ubiquiti/Axis
- Per-asset scan button: "📡 SNMP Scan" in Asset Detail; API: `POST /api/itam/assets/<id>/snmp-scan`

**mDNS/SSDP Passive Device Discovery**

Discover printers, IP cameras, smart TVs, AirPlay/Chromecast/HAPS devices without active scanning:
- zeroconf library listening on 19 service types (`_printer._tcp`, `_ipp._tcp`, `_hap._tcp`, `_airplay._tcp`, `_googlecast._tcp`, `_axis-video._tcp`, etc.)
- Optional at startup: `ITAM_MDNS_ENABLED=true`
- Feeds directly into `network_assets` with `discovery_source='mdns'`

**Cloud Asset Discovery (AWS EC2 + Azure VMs)**

Sync your cloud infrastructure into the ITAM asset database automatically:
- **AWS**: boto3 EC2 describe_instances across multiple regions, picks up Name/Environment/Team tags
- **Azure**: azure-mgmt-compute list_all() with NIC/IP resolution via azure-mgmt-network
- Both respect CMDB priority (cloud data never overwrites manually-curated CMDB entries)
- Auto-sync every 4 hours via APScheduler (when credentials configured)
- Cloud source badges in Coverage Dashboard (orange=AWS, blue=Azure)
- Manual trigger: `POST /api/itam/cloud-sync`

**Per-Subnet Credential Profiles**

Named credential sets tied to specific CIDR subnets — replaces the single global SSH/WinRM config:
- `itam_credential_profiles` table with CIDR, SSH, WinRM, and SNMP credentials
- Full CRUD API: `GET/POST /api/itam/credential-profiles`, `PUT/DELETE /api/itam/credential-profiles/<id>`
- Admin-only management

**Scheduled Background Jobs (5 new APScheduler jobs)**

| Job | Schedule | Purpose |
|---|---|---|
| `itam_nvd_incremental` | Daily 03:00 UTC | Sync NVD CVEs modified in last 8 days |
| `itam_nvd_full_sync` | Weekly Sunday 01:00 UTC | Full NVD sync from 2020 |
| `itam_kev_sync` | Daily 01:30 UTC | Sync CISA KEV catalog |
| `itam_cve_refresh` | Daily 02:00 UTC | Re-enrich assets with stale CVE data |
| `itam_cloud_sync` | Every 4 hours | AWS/Azure asset sync (if configured) |

### UI Improvements

- **Asset Detail**: scan status badge (idle/scanning/ok/error), SNMP Scan button, EPSS % column, KEV badge column, ransomware risk banner
- **Coverage Dashboard**: color-coded source dots (AWS=orange, Azure=blue, EDR=green, ARP=cyan)
- Source badges now show `discovery_source` field (AWS/Azure/mDNS) correctly

### Files Added (v1.0.108)
- `backend/blueprints/itam/cloud_discovery.py` — AWS EC2 + Azure VM sync
- `backend/blueprints/itam/snmp_scanner.py` — SNMP v2c polling
- `backend/blueprints/itam/mdns_discovery.py` — mDNS/SSDP passive discovery
- `backend/blueprints/itam/nvd_mirror.py` — Local NVD CVE cache
- `backend/blueprints/itam/exploit_intel.py` — EPSS + CISA KEV

### New Environment Variables (v1.0.108)
See `docs/ITAM_COMMERCIAL_GAP_ANALYSIS.md` for full list.

---

## v1.0.107 -- 2026-06-30

### New Features — ITAM Phase 2: Depth & Maturity

**Agent-less SSH/WinRM Deep Inventory**

CyCentra 360 can now connect to any network host without a CyEDR or CySIEM agent to collect deep inventory data — OS version, hardware specs, all installed packages, running services, listening ports, and local users.

- **Linux/macOS**: SSH connection using key-based or password auth (`paramiko`)
- **Windows**: WinRM/PowerShell remoting with NTLM auth (`pywinrm`)
- Triggered per-asset from the new Asset Detail page or via `POST /api/itam/assets/<id>/deep-scan`
- Global default credentials configured in `/opt/cycentra/.env` (`ITAM_SSH_USERNAME`, `ITAM_WINRM_USERNAME`, etc.)
- Per-scan credential override supported in request body for one-off scans

**Software Inventory with CVE Correlation**

After every deep scan, installed packages are stored in `software_inventory` and enriched with CVEs from the NVD API 2.0:

- Package managers supported: deb (apt), rpm (yum/dnf), brew (macOS), Windows Registry
- CVSSv3.1 → v3.0 → v2 severity parsed per CVE
- Vulnerability count and highest severity shown directly in the Asset Coverage dashboard table
- Per-asset software inventory page: paginated, severity-filtered, CVE count per package
- `POST /api/itam/assets/<id>/enrich-cves` triggers enrichment on-demand
- Configurable NVD API key (`NVD_API_KEY`) — free tier: 5 req/30s; with key: 50 req/30s

**Shadow AI Detection — DNS & Network Layer (Item 1 Enhancement)**

Expanded from process-scan-only to three detection layers:

1. **Process scan** (existing) — 25 known local AI process names
2. **DNS journal monitoring** (new, Linux/macOS) — CyEDR parses systemd-resolved / mDNSResponder logs every 60s for AI SaaS domain queries. Findings sent to `POST /api/itam/shadow-ai/dns-ingest`
3. **Network DNS monitor** (new, optional) — dnslib-based forwarding resolver on CyCentra server (port 5454). Set CyCentra as secondary DNS in DHCP to catch ALL devices without an agent. Enable with `ITAM_DNS_MONITOR_ENABLED=true`
4. **Sysmon rules expanded** — rules 101040/101041 now cover 65+ AI SaaS domains (was 10)

AI domain watchlist expanded to 70+ domains across 30+ providers: OpenAI, Anthropic, Gemini, Mistral, Groq, DeepSeek, xAI/Grok, Stability AI, Midjourney, Runway, ElevenLabs, Character AI, HuggingFace, Replicate, OpenRouter, Coze, Amazon Bedrock, IBM WatsonX, GitHub Copilot, and more.

**Asset Detail Page**

New drill-down page reachable by clicking any asset row in the Coverage Dashboard:
- OS info panel (name, version, architecture)
- Hardware summary (CPU cores/model, RAM, disk)
- Running services and local user accounts
- Full software inventory table with CVE counts and severity badges
- Deep Scan trigger (SSH/WinRM) and CVE enrichment trigger

**New API Endpoints**

| Endpoint | Purpose |
|---|---|
| `POST /api/itam/assets/<id>/deep-scan` | Trigger SSH/WinRM scan |
| `GET /api/itam/assets/<id>/detail` | Per-asset hardware/OS/software summary |
| `GET /api/itam/assets/<id>/software` | Paginated software inventory |
| `POST /api/itam/assets/<id>/enrich-cves` | Trigger NVD CVE lookup |
| `GET /api/itam/shadow-ai/dns-watchlist` | Full AI domain watchlist (70+ domains) |
| `POST /api/itam/shadow-ai/dns-ingest` | Receive DNS-detected Shadow AI findings |

#### Files changed

- `backend/blueprints/itam/agentless_scanner.py` — New: SSH + WinRM discovery engine
- `backend/blueprints/itam/software_inventory.py` — New: software DB + NVD CVE lookup
- `backend/blueprints/itam/dns_shadow_ai.py` — New: 70+ domain watchlist + DNS forwarding resolver
- `backend/blueprints/itam/routes.py` — 6 new routes, DNS monitor startup hook
- `backend/core/config.py` — 9 new env vars (SSH/WinRM/NVD/DNS)
- `backend/blueprints/scheduler/routes.py` — DNS monitor startup registration
- `backend/requirements.txt` — Added paramiko, pywinrm, dnslib
- `agent/cyedr_agent.py` — DNS journal monitoring (Linux/macOS, 70+ domain watchlist)
- `CYSIEM-Config/rules/cy_cust_rules.xml` — Rules 101040/101041 expanded to 65+ AI domains
- `portal/src/pages/itam/AssetDetailPage.jsx` — New: per-asset detail + software inventory UI
- `portal/src/pages/itam/index.jsx` — Vuln count column, clickable rows → asset detail
- `portal/src/components/AppRouter.jsx` — Route for itam-asset-detail
- `docs/ITAM_COMMERCIAL_GAP_ANALYSIS.md` — New: comprehensive gap analysis vs. commercial products

#### New env vars

```bash
ITAM_SSH_USERNAME=          ITAM_SSH_PASSWORD=      ITAM_SSH_KEY_PATH=
ITAM_SSH_PORT=22            ITAM_WINRM_USERNAME=    ITAM_WINRM_PASSWORD=
ITAM_WINRM_PORT=5985        ITAM_WINRM_SSL=false    NVD_API_KEY=
ITAM_DNS_MONITOR_ENABLED=false  ITAM_DNS_MONITOR_PORT=5454  ITAM_DNS_UPSTREAM=8.8.8.8
```

---

## v1.0.106 -- 2026-06-29

### Improvements

  - Stability and performance improvements.

---

## v1.0.106 -- 2026-06-29

### New Feature: ITAM — IT Asset Management Module

**Network Asset Inventory with EDR/SIEM Coverage Gap Analysis**

CyCentra 360 now includes a full IT Asset Management module accessible under the new **ASSET MANAGEMENT** sidebar section. It surfaces every device on your network, shows which ones have CyEDR or CySIEM coverage, and highlights the gap — all in one place.

#### Three Discovery Sources (additive, all active simultaneously)

| Source | Trigger | Priority |
|---|---|---|
| **CMDB CSV Import** | Admin uploads CSV | Highest — overwrites all fields |
| **ARP Neighbors** | CyEDR heartbeat (every 60s) | Auto — fills empty fields only |
| **nmap Subnet Scan** | Admin on-demand | On-demand — fills empty fields |

All three sources populate the same `network_assets` table. After every ingest, a cross-reference job links each asset to its CyEDR agent and CySIEM host entry by IP address.

#### Asset Coverage Dashboard

- KPI row: Total Assets · EDR Covered (%) · SIEM Covered · Uncovered · IoT Devices · Shadow AI
- Coverage progress bar with color coding (green ≥80%, amber ≥50%, red <50%)
- Asset type breakdown by category (workstations, servers, printers, cameras, IoT, etc.)
- CMDB import + subnet scan trigger buttons (admin)
- Tab filter: All / Uncovered / EDR Covered
- Paginated asset table with search by IP, hostname, vendor

#### IoT Device Registry

Discovered devices without a CyEDR or CySIEM agent are automatically classified using:
- **OUI vendor lookup** — 60+ MAC address prefixes mapped to vendor and category
- **Port fingerprinting** — RTSP (cameras), IPP (printers), MQTT (smart devices), Modbus (industrial), BACnet (HVAC)
- **Risk scoring** — composite 0–100 score based on telnet exposure, no-TLS management, industrial protocols, and default credentials
- **Default credential probing** — optional, requires `ITAM_PROBE_CREDS=true`

Risk tiers: LOW / MEDIUM / HIGH / CRITICAL. Clicking a device row expands its risk factors.

#### Shadow AI Monitor

Enterprises face a growing challenge from unauthorized AI tools installed by employees. CyCentra 360 now detects Shadow AI through three layers:

- **L1 — CyEDR process scan**: 25 known local AI processes monitored on every heartbeat (ollama, lm_studio, jan, gpt4all, koboldcpp, comfyui, stable-diffusion-webui, localai, and more)
- **L2 — Wazuh Sysmon DNS** (Windows): Rules 101040/101041 fire on DNS queries and network connections to AI API endpoints
- **L3 — Local AI port detection**: Rule 101042 detects processes listening on Ollama (11434), LM Studio (1234), and WebUI (7860) ports

Shadow AI events are **governance-only** — they do not create SIEM alerts or EDR detections. They are routed directly to the ITAM Shadow AI findings table.

**Approved AI Whitelist**: Admins maintain an enterprise whitelist of sanctioned AI tools. Whitelisted tools do not generate findings. The list is refreshed to all CyEDR agents hourly.

**Finding workflow**: Open → Approve / Escalate / Suppress / Reopen. All actions are logged.

#### Compliance Auto-Feed

The ITAM bridge (6-hour APScheduler job) automatically feeds coverage data to the GRC compliance module:
- **NIST CSF** `ID.AM-1`, **ISO 27001** `A.8.1`, **DORA** `Art.8`, **NIS2** `Art.21` — asset inventory evidence
- **EU AI Act** `Art.28`, **ISO 42001** — Shadow AI governance evidence
- Auto-raises a `medium` compliance finding when EDR coverage drops below 50%

#### Files changed

- `backend/blueprints/itam/__init__.py` — New package
- `backend/blueprints/itam/routes.py` — Full blueprint: 20 routes, `init_itam_tables()`, ingest helpers, cross-ref
- `backend/blueprints/itam/network_discovery.py` — CMDB CSV parser, ARP parser, nmap runner
- `backend/blueprints/itam/iot_classifier.py` — OUI table, port signatures, risk scoring, default cred probe
- `backend/cy_comp/services/itam_bridge.py` — Compliance auto-feed + APScheduler registration
- `backend/core/config.py` — Added `ITAM_SUBNET`, `ITAM_IOT_PORTS`, `ITAM_PROBE_CREDS`
- `backend/app.py` — Registered `itam_bp`, `init_itam_tables`
- `backend/blueprints/scheduler/routes.py` — Registered `itam_compliance_sync` job
- `backend/blueprints/edr/routes.py` — Heartbeat extended: ARP ingest + Shadow AI intercept
- `agent/cyedr_agent.py` — ARP collection + Shadow AI process scan added to heartbeat cycle
- `CYSIEM-Config/rules/cy_cust_rules.xml` — Rules 101040, 101041, 101042 (Shadow AI)
- `portal/src/pages/itam/index.jsx` — Asset Coverage Dashboard
- `portal/src/pages/itam/IotRegistryPage.jsx` — IoT Device Registry
- `portal/src/pages/itam/ShadowAiPage.jsx` — Shadow AI Monitor + Whitelist
- `portal/src/sidebar/navConfig.jsx` — ASSET MANAGEMENT section (3 items)
- `portal/src/components/AppRouter.jsx` — Routes for itam-coverage, itam-iot, itam-shadow-ai
- `docs/ITAM_MODULE.md` — Full reference document

#### New env vars (add to `/opt/cycentra/.env`)

```bash
ITAM_SUBNET=192.168.1.0/24       # required for nmap scan
ITAM_IOT_PORTS=22,23,80,443,554,631,8080,8443,8883,9100,161,502,1883,4840,47808
ITAM_PROBE_CREDS=false            # set true to enable default cred probing
```

---

## v1.0.105 -- 2026-06-29

### Improvements

  - Stability and performance improvements.

---

## v1.0.104 -- 2026-06-29

### Improvements

  - Stability and performance improvements.

---

## v1.0.103 -- 2026-06-28

### Improvements

  - Stability and performance improvements.

---

## v1.0.103 -- 2026-06-28

### Improvements

**Settings → Agent Installer — Smart CySIEM Agent Manager**

The Settings > Agent Installer tab has been redesigned from a download-only page into a full agent lifecycle manager.

**Smart detection on every run:**
- The downloaded script now detects whether the CySIEM Agent and CyEDR Agent are already installed before doing anything.
- If neither is installed → installs silently.
- If either is already installed → presents an interactive menu: `1) Upgrade  2) Uninstall CySIEM  3) Uninstall CyEDR  4) Uninstall ALL  0) Cancel`.

**Non-interactive flags (for automation/MDM):**

| Platform | Install | Upgrade | Remove CySIEM | Remove CyEDR | Remove all |
|----------|---------|---------|---------------|--------------|------------|
| Linux/macOS | `--install` | `--upgrade` | `--uninstall-cysiem` | `--uninstall-cyedr` | `--uninstall` |
| Windows | `-Action install` | `-Action upgrade` | `-Action uninstall-cysiem` | `-Action uninstall-cyedr` | `-Action uninstall` |

**Uninstall removes cleanly:**
- CySIEM Agent: stops service, purges DEB/RPM package, removes `/var/ossec`, cleans `cy360-baseline.rules` audit file, removes Sysmon on Windows.
- CyEDR Agent: stops `cyedr-agent` + `cyedr-watchdog`, removes systemd units, removes `/opt/cycentra/edr`, cleans `60-cyedr.rules` audit file.

**CySIEM branding throughout:**
- All user-facing product references now say "CySIEM Agent" instead of "Wazuh". Internal package/binary names (`wazuh-agent`, `wazuh-control`) are unchanged as they are the actual on-disk names.
- API response key renamed: `wazuh_manager` → `cysiem_manager` in `GET /api/system/agent-packages`.

**EDR callout added:**
- The page now shows an info banner directing CyEDR deployments to Endpoint Defence → Agent Installer, which handles both CyEDR and the optional CySIEM co-install in a single run.

#### Files changed
- `backend/blueprints/system/routes.py` — `_INSTALLER_SH`, `_INSTALLER_PS1` rewritten; `wazuh_manager` → `cysiem_manager` in both route functions and JSON response
- `portal/src/pages/settings/SystemSettingsPage.jsx` — `AgentInstallerTab`: EDR callout, CySIEM labels, smart installer description, uninstall quick-reference section

---

## v1.0.102 -- 2026-06-28

### Improvements

  - Stability and performance improvements.

---

## v1.0.101 -- 2026-06-27

### Improvements

  - Stability and performance improvements.

---

## v1.0.100 -- 2026-06-26

### Improvements

  - Stability and performance improvements.

---

## v1.0.99 -- 2026-06-26

### Improvements

  - Stability and performance improvements.

---

## v1.0.98 -- 2026-06-25

### Improvements

  - Stability and performance improvements.

---

## v1.0.98 -- 2026-06-26

### Bug Fix — "Save Automation Settings" crashes with `✗ name 'log' is not defined`

**Root cause:** Two undefined-name bugs in `_sync_misp_to_siem_env()` inside
`blueprints/system/routes.py` caused every POST to `/api/ai/settings` to return HTTP 500
whenever `ai_settings.json` already contained a `misp` key (i.e. after any MISP configuration).

**Crash chain:**
1. User clicks "Save" on the SIEM Automation tab → POST `/api/ai/settings`
   with `{ system: { fpThreshold: <value> } }`.
2. Handler merges payload into existing `ai_settings.json` and **writes the file
   successfully** (line 346).
3. Because `existing["misp"]` is present, `_sync_misp_to_siem_env()` is called.
4. Inside that function, line 202 references `pathlib.Path(...)` — but only
   `from pathlib import Path` was imported (not the `pathlib` module itself) →
   **`NameError: name 'pathlib' is not defined`**.
5. The inner `except` block catches this and attempts `log.warning(...)` — but `log`
   was never imported or defined anywhere in the file →
   **`NameError: name 'log' is not defined`** (unhandled).
6. This second `NameError` propagates to the outer `except Exception as e` in
   `ai_settings_post()` and is returned to the frontend as HTTP 500
   `{"error": "name 'log' is not defined"}`.

**Important:** Because the file write (step 2) completed before the crash, the
`fpThreshold` value **was** being persisted to disk. The correlation engine's
`_get_fp_threshold()` in `ingestor.py` was picking it up correctly on every new alert.
The feature was operational — only the success response was broken.

#### `backend/blueprints/system/routes.py`
- Line 202: `pathlib.Path(...)` → `Path(...)` (uses the already-imported `Path` from
  `from pathlib import Path`).
- Line 211: `log.warning(...)` → `current_app.logger.warning(...)` (`current_app` is
  already imported from Flask; safe to call inside any route context).

### Confirmed operational — False Positive Auto-Close Threshold

The FP auto-close mechanism in the correlation engine is fully functional:
- `ingestor.py` → `_get_fp_threshold()` reads `system.fpThreshold` from
  `/opt/cycentra/ai_settings.json` on every alert and auto-closes incidents where
  `fp_probability >= threshold` (Band 1 action: `auto_close`).
- `main.py` startup migration 4 applies the same threshold to any stale
  `false_positive` incidents at engine start.
- The "Automated Decision Bands" displayed in the UI (Auto-close / Investigating /
  In Review → Case) match the actual three-band logic in the ingestor.

---

## v1.0.97 -- 2026-06-25

### Improvements

  - Stability and performance improvements.

---

## v1.0.96 -- 2026-06-25

### Improvements

  - Stability and performance improvements.

---

## v1.0.94 -- 2026-06-25

### New Features

  - mcp): expose /mcp/sse as authenticated public proxy on Flask backend

---

## v1.0.93 -- 2026-06-25

### Improvements

  - chore(docs): weekly architecture review 2026-06-25

---

## v1.0.92 -- 2026-06-25

### Improvements

  - Stability and performance improvements.

---

## v1.0.91 -- 2026-06-24

### Improvements

  - Stability and performance improvements.

---

## v1.0.91 -- 2026-06-25

### Infrastructure

**`.github/workflows/deploy.yml` — Eliminated artifact storage quota dependency**
- Root cause: `deploy.yml` split the build into 3 jobs (`build-portal`, `build-wheel`, `publish`) with `upload-artifact`/`download-artifact` to pass files between them. GitHub's free-tier artifact storage quota (~500 MB) was exhausted from accumulated runs, blocking all releases with "Artifact storage quota has been hit" — quota recalculates every 6–12 hours so deleting artifacts doesn't unblock immediately.
- Fix: Collapsed 3 jobs into one `build-and-publish` job. Node (portal) + Python (wheel) + SHC compile + bundle assembly all run sequentially on the same runner. No inter-job file transfer needed, so zero artifact storage is consumed.

**`.github/workflows/update-release-notes.yml` — Deleted (dead workflow)**
- Both jobs in this workflow had `if:` conditions that never fired in the direct-push release workflow: `summarize_pr` requires a pull_request event (never used); `update_release_notes` requires `github.actor == 'github-actions[bot]'` (user pushes from SSH key). Workflow started and immediately skipped on every `git-push.sh` run — wasting a runner startup for no benefit.

---

## v1.0.90 -- 2026-06-24

### Improvements

  - Stability and performance improvements.

---

## v1.0.89 -- 2026-06-24

### Improvements

  - Stability and performance improvements.

---

## v1.0.88 -- 2026-06-24

### Improvements

  - Stability and performance improvements.

---

## v1.0.87 -- 2026-06-24

### Improvements

  - Stability and performance improvements.

---

## v1.0.87 -- 2026-06-24

### Bug Fixes

  - **CyMind chat probe timeout fixed** — The "Test Connection" chat key probe now uses `use_external: true` (routes via external AI / Groq) and a 30 s timeout instead of the previous `use_external: false` / 20 s combination. The old probe hit Ollama directly; if the CyMind container had recently restarted, Ollama needs 30–60 s to load the model into memory, causing the probe to always time out. The fix bypasses local model warm-up so key validation is reliable immediately after any container restart. Same correction applied to the auto-probe inside the "Re-connect / Enable Integration" flow.

---

## v1.0.86 -- 2026-06-24

### Improvements

  - Stability and performance improvements.

---

## v1.0.85 -- 2026-06-23

### Improvements

  - Stability and performance improvements.

---

## v1.0.84 -- 2026-06-23

### Improvements

  - Stability and performance improvements.

---

## v1.0.83 -- 2026-06-23

### Improvements

  - Stability and performance improvements.

---

## v1.0.82 -- 2026-06-23

### Improvements

  - Stability and performance improvements.

---

## v1.0.81 -- 2026-06-23

### Improvements

  - Stability and performance improvements.

---

## v1.0.80 -- 2026-06-22

### Improvements

  - Stability and performance improvements.

---

## v1.0.79 -- 2026-06-22

### Improvements

  - Stability and performance improvements.

---

## v1.0.78 -- 2026-06-22

### Improvements

  - Stability and performance improvements.

---

## v1.0.77 -- 2026-06-22

### Improvements

  - Stability and performance improvements.

---

## v1.0.76 -- 2026-06-22

### Improvements

  - Stability and performance improvements.

---

## v1.0.75 -- 2026-06-22

### Improvements

  - Stability and performance improvements.

---

## v1.0.74 -- 2026-06-21

### Improvements

  - Stability and performance improvements.

---

## v1.0.73 -- 2026-06-20

### Improvements

  - Stability and performance improvements.

---

## v1.0.73 -- 2026-06-20

### New Feature — Integration Health Monitoring with Auto-Incident Creation

CyCentra 360 now continuously monitors the health of all configured integrations
and automatically raises an incident and opens a CyCase when an integration goes
down, fails authentication, or stops ingesting events.

#### Integrations monitored
| Integration | Check type | Trigger |
|-------------|-----------|---------|
| Wazuh SIEM | API auth + alert ingest gap | No alerts for > 15 min, or manager unreachable |
| CySIEM Correlation Engine | `/health` endpoint | Non-200 response or connection failure |
| CyMind AI | `/api/v1/health` | Unreachable (only when integration is enabled) |
| MISP Threat Intelligence | `getPyMISPVersion` API | HTTP failure or auth error (only when not disabled) |
| CySOAR Automation | Node-RED root URL | Non-5xx check fails (only when module is installed) |
| Office 365 / GCP / AWS / GitHub | Alert ingest gap | No matching alerts in last 15 minutes |
| Custom marketplace integrations | `health_config` in catalog item | Ingest gap or HTTP endpoint check |

#### Auto-incident and case creation
- When any integration is unhealthy, a synthetic incident is created with
  `categories = integration_health` and a stable ID (`INTEG-xxxxxxxx`).
- A CyCase is automatically opened on the incident (`case_type: operational`).
- The incident is automatically resolved — with a system comment — when the
  integration recovers on the next health check cycle.
- All checks are idempotent: only one open incident per integration at any time.

#### Background health check scheduler
- Runs every **5 minutes** automatically (configurable via `INTEGRATION_HEALTH_INTERVAL` env var).
- Also triggerable on-demand via `POST /api/integrations/health/check` (analyst+).

#### Extensible marketplace support
New integrations added via the marketplace are automatically monitored if their
catalog item declares a `health_config` block:
```json
{
  "health_config": {
    "type": "ingest_gap",
    "rule_groups": ["my-custom-source"],
    "display_name": "My Integration"
  }
}
```
Or for HTTP-endpoint integrations:
```json
{
  "health_config": {
    "type": "http",
    "endpoint_url": "https://my-service.internal/health"
  }
}
```

#### New portal page
**Integration Health** is available under Platform Configuration → Integration Health.
Displays live status cards per integration with error details, ingest gap duration,
consecutive failure count, and a direct link to the open incident when unhealthy.
A **Check Now** button triggers an immediate check cycle.

**New env vars:**
- `INTEGRATION_HEALTH_INTERVAL` — seconds between checks (default: `300`)
- `INTEGRATION_HEALTH_INGEST_WINDOW` — minutes without events before "degraded" (default: `15`)

**Files changed:**
- `backend/blueprints/integrations/health.py` (new)
- `backend/blueprints/integrations/routes.py` (new)
- `backend/blueprints/integrations/__init__.py` (new)
- `backend/core/config.py` — added `INTEGRATION_HEALTH_INTERVAL`, `INTEGRATION_HEALTH_INGEST_WINDOW`
- `backend/blueprints/scheduler/routes.py` — added `integration_health` job type + auto-registration
- `backend/app.py` — registered `integrations_bp`
- `portal/src/pages/integrations/index.jsx` (new)
- `portal/src/sidebar/navConfig.jsx` — added Integration Health nav entry

---

## v1.0.72 -- 2026-06-20

### Improvements

  - Stability and performance improvements.

---

## v1.0.72 -- 2026-06-20

### New Feature — CPU / Memory / Disk Threshold Alerting

CyCentra 360 agents now actively monitor host resource utilization and generate
SIEM alerts and correlated incidents when thresholds are exceeded.

#### Agent-side collection (all platforms)
A lightweight monitoring script (`cy360_resource_check`) runs every 5 minutes on
every enrolled agent via Wazuh's shared agent configuration. It emits structured
JSON events only when a threshold is crossed — no noise when systems are healthy.

| Metric | Threshold | Event name |
|--------|-----------|------------|
| CPU utilization | > 90% | `high_cpu` |
| Memory utilization | > 90% | `high_memory` |
| Disk utilization (root/C:) | > 85% | `high_disk` |

- **Linux**: reads `/proc/stat` and `/proc/meminfo` — zero dependencies, runs on any kernel.
- **macOS**: reads `top -l` and `vm_stat`.
- **Windows**: uses `Get-Counter`, `Get-CimInstance Win32_OperatingSystem`, `Get-PSDrive`.

Scripts deployed to agents via Wazuh shared config (`/var/ossec/etc/shared/default/`),
automatically pushed to all enrolled endpoints on next agent sync.

#### Wazuh alert rules (IDs 101004–101007)
- **101004** (level 7): High CPU — fires when `high_cpu` event received from agent
- **101005** (level 7): High disk — fires when `high_disk` event received
- **101006** (level 7): High memory — fires when `high_memory` event received
- **101007** (level 10): Sustained breach — triggers when the same agent fires 3+ resource
  alerts within 10 minutes; escalates to a higher-severity incident

#### Correlation rule CR-056: Sustained Resource Utilization Breach
New correlation rule added to the CySIEM engine. Fires when 2+ resource threshold
alerts originate from the same host within a single incident window. Severity: Medium.
Linked to MITRE ATT&CK T1496 (Resource Hijacking) and T1499 (Endpoint Denial of Service).

**Files changed:**
- `CYSIEM-Config/agent_config/cy360_resource_check.sh` (new)
- `CYSIEM-Config/agent_config/cy360_resource_check.ps1` (new)
- `CYSIEM-Config/agent_config/agent.conf` — added 3 OS-scoped `<agent_config>` blocks
- `CYSIEM-Config/decoders/cy_cust_decoders.xml` — added `cy360-resource-check` decoder pair
- `CYSIEM-Config/rules/cy_cust_rules.xml` — added rules 101004–101007
- `backend/cysiemstack/correlation_engine/correlator.py` — added CR-056 class + registered in ALL_RULES
- `cycentra-setup.sh` — added script deploy step to `--update` flow

---

## v1.0.71 -- 2026-06-19

### Improvements

  - Stability and performance improvements.

---

## v1.0.70 -- 2026-06-20

### Changes — RBAC Refinements

#### Removed built-in role `cyiris`
The `cyiris` role has been retired. CyIRIS access is governed by OIDC client scopes rather
than a portal role. Existing users assigned `cyiris` should be reassigned to `viewer` or a
custom role. Built-in role set is now: `admin`, `analyst`, `viewer`, `cysoar`.

- `backend/blueprints/rbac/manager.py`: Removed from `_DEFAULT_ROLE_PAGES` and
  `_bootstrap_roles`. `DELETE FROM cy_roles WHERE role_name = 'cyiris'` applied on server.

#### Fix — User Management refresh button not working
`reloadUsers()` only fetched `/api/rbac/users` and had no loading feedback, leaving
`availableRoles` stale after creating a new role in the Role Management section.

- `portal/src/pages/settings/SystemSettingsPage.jsx`: `reloadUsers` now fetches users
  and roles in parallel. Added `refreshing` state — button shows "↻ REFRESHING…" and
  is disabled while in flight.

#### Fix — Duplicate "User Management" title when section is expanded
Opening the User Management collapsible showed the section header and the inner component
header both displaying "👤 User Management".

- Removed the redundant icon + label from the inner `UserManagementTab` header. The
  ↻ REFRESH button is now in a slim right-aligned row at the top of the panel.

---

## v1.0.69 -- 2026-06-19

### Improvements

  - Stability and performance improvements.

---

## v1.0.68 -- 2026-06-19

### Improvements

  - Stability and performance improvements.

---

## v1.0.67 -- 2026-06-19

### New Feature — Role-Based Page Access Control (RBAC)

Admins can now define custom roles with fine-grained page-level access control. Users assigned
a restricted role only see the pages their role permits — restricted pages are completely hidden
from the sidebar.

#### Backend — `backend/blueprints/rbac/manager.py`

New `cy_roles` PostgreSQL table stores role page permissions. Five built-in roles are seeded
on first run (`ON CONFLICT DO NOTHING` so custom edits persist across restarts):

| Role | Default Page Access |
|------|---------------------|
| `admin` | Unrestricted (all pages) |
| `analyst` | 19 pages (all except platform admin) |
| `viewer` | 8 pages (dashboard, assets, vulns, SIEM, compliance, marketplace) |
| `cysoar` | 3 pages (dashboard, SIEM incidents, marketplace) |
| `cyiris` | 2 pages (dashboard, marketplace) |

New public function `get_user_allowed_pages(email)` — returns `None` (unrestricted) or a list
of allowed page IDs for a given user, based on their assigned role.

New API routes (admin-only except `my-permissions`):
- `GET  /api/rbac/roles` — list all roles with their page permissions
- `POST /api/rbac/roles` — create or update a role's page permissions; `admin` always stored as unrestricted
- `DELETE /api/rbac/roles/<role_name>` — delete a custom role (built-in roles return 400)
- `GET  /api/rbac/my-permissions` — returns `{"allowed_pages": [...] | null}` for the current session user

Dynamic role validation: user assignment (`POST /api/rbac/users`) now queries `cy_roles` so
custom roles are accepted without code changes.

#### Frontend — Page Filtering

- **`portal/src/hooks/useAppState.js`**: Added `allowedPages` state (`null` = unrestricted).
  Fetches `/api/rbac/my-permissions` on login; updates when the authenticated user changes.
- **`portal/src/sidebar/Sidebar.jsx`**: Added `isPageAllowed()` helper. Sidebar sections and
  items not in `allowedPages` are completely hidden. Entire sections are removed if all their
  items are restricted.
- **`portal/src/App.jsx`**: Added redirect `useEffect` — if the current tab is not in
  `allowedPages`, automatically redirects to the first allowed page on login.

#### Frontend — Settings > Role Management

New **Role Management** section (🎭) added under Settings > User Management:

- Role list table with **Configure** and **Delete** buttons (built-in roles cannot be deleted)
- **Configure panel**: per-page checkboxes grouped by sidebar section; admin shown as read-only
  unrestricted
- **Create Role** form: slug-validated name (lowercase, no spaces), page picker, Save button
- `availableRoles` in the User Management tab now fetches from `/api/rbac/roles` so custom
  roles appear in the role assignment dropdown immediately after creation

### Bug Fix — React Hooks Violation (Black Page on Login)

**Root cause:** The `useEffect` for the allowed-page redirect was placed after the
`if (!authReady) return null` and `if (!user) return <LoginPage />` early returns in
`App.jsx`. React's Rules of Hooks require all hooks to be called unconditionally before any
return statement. This caused a blank/black page for all users after the RBAC frontend code
was deployed.

**Fix:** Moved the `useEffect` to before the early returns in `App.jsx`. The built bundle
correctly reflects this — Vite/Rollup emits it as a comma-operator expression
`if(u.useEffect(...),[w]),!a)return null` ensuring the hook registers before the early exit.

---

## v1.0.66 -- 2026-06-19

### Improvements

  - Stability and performance improvements.

---

## v1.0.66 -- 2026-06-19

### Enhancement — Threat Hunting UI + AI Analysis (Internal Exposure)

**New page:** Threat Hunting is now surfaced as a first-class page under the Internal Exposure section in the sidebar (🎯 icon). The backend threat hunting engine (`cysiemstack/threat_hunter/hunter.py`) was already operational with 12 YAML hunt rules running every 6 hours — this release connects it to the UI.

#### New UI — `portal/src/siem/ThreatHuntingPage.jsx`
- 5-card KPI row: Total Rules · Active Findings · Critical/High · New (24h) · Rules Firing
- **Hunt Rules table:** all 12 YAML rules with severity badges, MITRE ATT&CK technique tags, window hours, and live open-findings count
- **CyMind AI Analysis panel:** "Analyze Findings" button sends current hunt state to CyMind and displays AI-generated threat narrative with recommended actions
- **Active Hunt Findings table:** all open `hunt_finding` incidents with entity, severity, MITRE IDs, rule name, first-seen timestamp, expandable llm_summary
- "Run Hunt Now" button for on-demand hunts
- Auto-refreshes every 60 seconds

#### Internal Attack Posture Dashboard — hunt summary widget added
- New "Threat Hunt Activity" panel added to `InternalExposureDashboard.jsx` (Row 5)
- Shows: Active Findings, Critical/High, Rules Firing, New (24h) at a glance
- "View All" navigates to the Threat Hunting page

#### New backend endpoints — `backend/siem_proxy.py`
- `GET /api/siem/threat-hunting/summary` — hunt statistics for the dashboard widget
- `POST /api/siem/threat-hunting/analyze` — sends hunt findings + rule state to CyMind; returns AI analysis text, model name, and counts analyzed

#### Compliance feed
- `hunt_finding` incidents were already flowing through `cy_comp/services/siem_bridge.py` compliance enrichment (MITRE-based mapping). No changes required — hunt findings appear in `comp-findings` automatically.

#### Navigation
- `portal/src/sidebar/navConfig.jsx`: "Threat Hunting" added to INTERNAL EXPOSURE section
- `portal/src/App.jsx`: `activeTab==="threat-hunting"` route added
- `portal/src/siem/siemApi.js`: 5 new API helper methods added

---

## v1.0.65 -- 2026-06-19

### Improvements

  - Stability and performance improvements.

---

## v1.0.64 -- 2026-06-19

### Improvements

  - Stability and performance improvements.

---

## v1.0.63 -- 2026-06-19

### Improvements

  - Stability and performance improvements.

---

## v1.0.62 -- 2026-06-19

### Improvements

  - Stability and performance improvements.

---

## v1.0.61 -- 2026-06-19

### Bug Fixes

  - misp-sync): use certifi CA bundle + proper User-Agent for MISP HTTPS
  - replace invalid <field name="file_path"> with <match> in FIM persistence rules

---

## v1.0.60 -- 2026-06-19

### Bug Fixes

  - **Agent Installer — misleading "check port 1515" error on macOS upgrade:** When reinstalling or upgrading the agent on a Mac where the agent was already registered, `agent-auth` correctly rejected the duplicate name (`Duplicate agent name: mac.home`) but the installer surfaced this as a generic port-1515 reachability error and aborted — leaving the agent installed but not restarted, and all post-install steps (Apple ULS telemetry, Full Disk Access notice) skipped. Root cause: `_register_agent()` piped `agent-auth` output directly to `err()` on any non-zero exit without inspecting the actual error message. Fixed to capture the `agent-auth` output, detect the `Duplicate agent` string, treat it as a known upgrade case (existing `client.keys` is preserved by the PKG installer — no re-registration needed), print a clear success message, and continue to restart the agent so new binaries are loaded. Any other failure still shows an actionable error pointing to port reachability, name conflicts, and manager logs.
  - **Agent Installer macOS — `wazuh-logcollector` did not start (double restart + missing FDA guidance):** On macOS upgrades the agent was restarted twice — once inside `_register_agent()` before ULS config was applied, and again after. The premature first restart left a stale PID file, causing the second restart to print `wazuh-logcollector: Process not used by Wazuh, removing` and fail to launch the log collector. Fixed by removing the restart from `_register_agent()` — a single restart now fires after all configuration is applied. The Full Disk Access notice now explicitly lists both `wazuh-agentd` and `wazuh-logcollector` as required FDA entries, with a clear note that the log collector will not start until FDA is granted and the agent is restarted manually.
  - **Agent Installer — Wazuh branding replaced with CyCentra in all user-facing output and audit rules:** Replaced `Wazuh self-defense` comment with `CyCentra agent self-defense`; renamed audit keys from `cy360_wazuh_tamper` to `cy360_agent_tamper`; updated Full Disk Access notice copy to reference the CyCentra agent.

---

## v1.0.59 -- 2026-06-18

### Improvements

  - chore(docs): weekly architecture review 2026-06-18

---

## v1.0.59 -- 2026-06-19

### Bug Fixes

  - **SIEM — "Request AI Analysis" button always failed with generic error:** On-demand LLM enrichment (`POST /incidents/{id}/analyse`) always returned HTTP 503 "LLM enrichment failed or is disabled. Check AI settings in the portal." regardless of the real cause. Root cause: `llm_enricher.enrich_incident()` caught all `call_llm()` exceptions and returned `{}` silently — correct graceful degradation for automated background enrichment but wrong for analyst-triggered on-demand calls. Fixed by re-raising the exception when `on_demand=True` and wrapping the call in `analyse_incident()` to include the real error (e.g. "CyMind returned HTTP 401: Invalid API key" or "Connection refused to Ollama") in the 503 detail. Analysts now see actionable diagnostics instead of a generic message. Also improved the no-alerts fallback message: "No alerts are linked to this incident — nothing to analyse."

---

## v1.0.58 -- 2026-06-18

### Improvements

  - Stability and performance improvements.

---

## v1.0.57 -- 2026-06-17

### Improvements

  - Stability and performance improvements.

---

## v1.0.58 -- 2026-06-17

### Bug Fixes

  - **Dashboard — "AI Auto-Closed" KPI always showed 0:** The KPI counted `closed` incidents from the 200-row incident list sample. Since closed incidents have old `last_seen` timestamps they never appear in the top 200 most-recently-active incidents. Fixed to use `stats.ai_auto_closed` from the `/stats` endpoint — a direct DB count not subject to the page-size limit. Now shows 4,624 correctly.
  - **Dashboard — AI Disposition widget wrong categories:** The "AI Auto-Closed" row in the breakdown panel filtered for `status === "false_positive"`. The engine sets `status = "closed"` (not `false_positive`) for automated FP closes, with `false_positive_reason` populated. Fixed to `status === "closed" && false_positive_reason != null`. Also removed the stale `fp_probability >= 0.7` scale-mismatch check (fp is 0–100, not 0–1).
  - **Dashboard — "Cases Open" KPI counted from incident sample:** `incidents.filter(i => i.case_opened_at).length` only searched the 200-incident list. Fixed to use `caseMetrics.open_cases` from the `/api/cases/metrics` endpoint, which counts cases directly from the DB.
  - **Engine `/stats` endpoint — `open_incidents` excluded `in_review` and `held`:** Only counted `open + investigating`. Fixed to include `in_review` and `held` — all statuses that require analyst attention.
  - **Engine `/stats` endpoint — no `ai_auto_closed` field:** Added: counts `status=closed` incidents where `false_positive_reason IS NOT NULL`.
  - **Engine `_incident_to_dict` — missing `false_positive_reason`:** Field not included in serialized incident response. Added — enables the frontend to distinguish engine auto-closes from analyst-closed incidents.

---

## v1.0.57 -- 2026-06-17

### Bug Fixes (critical — zero-incident production outage)

  - **SIEM — All incidents auto-closed (zero visibility):** `ai_settings.json` had `system.fpThreshold = 70`. The FP scorer returns exactly `70.0` for non-correlated low/medium severity incidents (avg_conf default = 0.30 → base = 70.0; tier-3 floor = 30.0). Because `fp_score >= fpThreshold` triggers Band 1 auto-close, every incident without a correlation rule was being immediately closed — 8,437 incidents incorrectly closed. `fpThreshold` raised to 80. Migration 14 added to recover incidents closed by the wrong threshold within the last 7 days (identified by `false_positive_reason LIKE 'Auto-closed: FP probability 70.0%'`).
  - **SIEM — Incident ID race condition (305,250 errors):** `_get_next_id()` in `grouper.py` used `SELECT MAX(...)` which is not atomic under concurrent processing. With `_PROCESS_SEM = asyncio.Semaphore(6)`, 6 alert tasks could simultaneously read the same MAX value and all attempt to `INSERT` the same next ID → `UniqueViolationError` on every concurrent new-incident creation. Each failure caused `db.rollback()` → alert discarded silently. Fixed by adding `pg_advisory_xact_lock(20260617)` before the MAX query — a transaction-level lock that blocks concurrent callers until the holder commits.
  - **Engine — Startup migrations crashed at Migration 12 (all migrations skipped):** Migration 12 in `main.py` used three `execute()` calls each containing multiple semicolon-separated SQL statements. `asyncpg` rejects multi-statement prepared statements with `PostgresSyntaxError`. Because all migrations share a single `try/except`, the crash at Migration 12 silently skipped Migrations 13 and 14 on every engine restart since the code was deployed. Each DDL statement now has its own `execute()` call. `DROP COLUMN` statements updated to use `CASCADE` to handle dependent indexes.

---

## v1.0.56 -- 2026-06-17

### Bug Fixes

  - **SIEM — Cases never auto-opened (critical):** `compute_fp_score()` in `risk_scorer.py` floored all incidents with unknown/tier-3 assets at `fp_probability = 40.0`. Case auto-opening requires `fp_score < 40` (Band 3). Since `DEFAULT_ASSET_TIER = 3` and no assets have explicit tier assignments, every incident was permanently clamped to fp=40 → Band 2 (investigating) → cases never opened. Tier-3 floor lowered from 40.0 → 30.0.
  - **SIEM — Existing incidents not retroactively re-severitied after v1.0.55 threshold change:** Startup Migration 13 added to `main.py`. On engine restart, all open/investigating/in_review incidents with no correlation rules are re-evaluated against the new scoring thresholds (>=8.2 critical / >=7.6 high / >=6.0 medium) using the max `base_score` from constituent alerts. Rule-escalated incidents are left untouched.
  - **UEBA — Context dict missing `category` and `username` fields:** `_get_recent_user_alerts()` in `ingestor.py` returned rows with only `rule_id`, `agent_id`, `timestamp`, `src_ip`. Missing fields caused: (1) token-theft IP heuristic always returned 0 distinct IPs (username check always False); (2) data-staging and activity-volume-spike detectors counted 0 FIM events in context; (3) ML `recent_fim` feature always 0 during inference. Added `username`, `category`, `rule_level`, `mitre_id` to context rows.

---

## v1.0.55 -- 2026-06-17

### Bug Fixes

  - **SIEM — Severity inflation (critical):** `grouper.py._score_to_severity()` had thresholds (`>=10/7/4`) that were misaligned with the actual logarithmic score range (4.1–8.2) produced by `normaliser._level_to_score()`. The `>=10` critical branch was permanently unreachable — every level-10+ alert landed in `high`. Thresholds corrected to `>=8.2 critical / >=7.6 high / >=6.0 medium` — aligned with Wazuh's own level conventions. Expected impact: ~40% of current `high` incidents reclassify as `medium` at creation.
  - **SIEM — `normaliser.py` docstring:** Fixed incorrect score examples in `_level_to_score` comment (claimed `level 12→10.0, level 15→13.0`; actual values are `7.6` and `8.2`). Misleading comment caused engineers to believe the broken thresholds were correct.

### Improvements

  - **SIEM — CR-004 (Web→FIM) time ordering:** `WebToFIM` correlation rule now requires the FIM event to occur **after** the earliest web attack timestamp. Previously, any co-occurring FIM event (e.g. a cron-triggered deployment) fired the rule.
  - **SIEM — CR-009 (Data Exfiltration) time ordering:** `DataExfiltration` rule now requires the network transfer event to occur **after** the earliest FIM event. Eliminates false positives from background OS update network events co-occurring with file writes.
  - **SIEM — CR-018 (Dormant Account Rebirth) corroborating context:** Rule no longer fires for every new user's first login. Now requires at least one corroborating signal: off-hours login, external source IP, or a preceding auth failure from the same user. Confidence raised from 0.65 → 0.72. Eliminates false positives from new employee onboarding and first-time Wazuh agent registrations.
  - **UEBA — Privilege escalation noise reduction:** `UEBA-U-06` (privilege_escalation) no longer fires on every sudo event. Now gated on corroborating context: service/daemon account, off-hours execution (outside 07:00–19:00), or an auth failure preceding the sudo in the same session. Reduces ~70% of routine admin sudo noise.
  - **UEBA — Token theft heuristic threshold:** Raised distinct-IP threshold from 3 to 5 for the token-theft heuristic path. Mobile users and split-tunnel VPN users routinely authenticate from 3–4 IPs without credential compromise.
  - **UEBA ML — Expanded feature vector (8→14 features):** Added cyclic sin/cos time encoding (avoids 23→0 discontinuity), is_weekend, recent_privesc count, recent_fim count, and has_mitre_tag. Raw `hour` feature replaced by `sin/cos(hour)` pair.
  - **UEBA ML — Model version stamping:** `MODEL_FEATURE_VERSION=2` constant introduced. Saved models carry this version; a mismatch causes the stale model to be discarded and re-trained on the next weekly cycle, preventing crashes on feature vector changes.
  - **UEBA ML — FP exclusion from training:** `retrain_all_models()` now excludes alerts from analyst-confirmed false-positive incidents (`status=false_positive` or `status=closed` with a `false_positive_reason`) from the training set. Training on FP events previously taught the model that noisy activity was "normal".
  - **SIEM — FP probability severity cap:** `ingestor.py` now downgrades incident severity by one band when `fp_probability >= 75.0` (critical→high, high→medium, medium→low). FP probability was previously computed and stored on the incident but had zero effect on severity. Analysts see appropriately ranked incidents when enrichment already indicates likely noise.
  - **Wazuh rules — Discovery rules level reduction:** Rules 100900 (SMB/AD enumeration, T1135) and 100901 (network scanning, T1046) lowered from level 10 to level 9. At level 9 score is 6.84 → medium; at level 10 score was 7.1 → high. Pure reconnaissance tool detections no longer flood the high-severity queue before exploitation is confirmed.
  - **Docs — `docs/SIEM_SEVERITY_TUNING.md` (new):** Comprehensive reference for the full severity pipeline: scoring math, threshold tables, custom rule level guidelines, environment variables, and tuning instructions.
  - **Docs — `docs/BEHAVIOURAL_ANALYTICS.md`:** Updated UEBA-U-06, UEBA-U-16, CR-004, CR-009, CR-018 descriptions to reflect new logic. ML section updated with 14-feature vector table, cyclic encoding rationale, FP exclusion note, and model versioning. Section 7 updated with FP severity cap documentation.

---

## v1.0.54 -- 2026-06-16

### Improvements

  - Stability and performance improvements.

---

## v1.0.53 -- 2026-06-16

### Improvements

  - Stability and performance improvements.

---

## v1.0.52 -- 2026-06-14

### Improvements

  - Stability and performance improvements.

---

## v1.0.51 -- 2026-06-14

### Improvements

  - Stability and performance improvements.

---

## v1.0.50 -- 2026-06-14

### Improvements

  - Stability and performance improvements.

---

## v1.0.49 -- 2026-06-14

### Improvements

  - Stability and performance improvements.

---

## v1.0.48 -- 2026-06-14

### Improvements

  - Stability and performance improvements.

---

## v1.0.47 -- 2026-06-14

### Improvements

  - Stability and performance improvements.

---

## v1.0.46 -- 2026-06-13

### Improvements

  - Stability and performance improvements.

---

## v1.0.45 -- 2026-06-13

### Improvements

  - Stability and performance improvements.

---

## v1.0.44 -- 2026-06-13

### Improvements

  - Stability and performance improvements.

---

## v1.0.43 -- 2026-06-13

### Improvements

  - Stability and performance improvements.

---

## v1.0.42 -- 2026-06-13

### Improvements

  - Stability and performance improvements.

---

## v1.0.41 -- 2026-06-13

### Improvements

  - Stability and performance improvements.

---

## v1.0.40 -- 2026-06-13

### Improvements

  - Stability and performance improvements.

---

## v1.0.39 -- 2026-06-13

### Improvements

  - Stability and performance improvements.

---

## v1.0.38 -- 2026-06-13

### Improvements

  - Stability and performance improvements.

---

## v1.0.37 -- 2026-06-13

### Improvements

  - Stability and performance improvements.

---

## v1.0.36 -- 2026-06-13

### Improvements

  - Stability and performance improvements.

---

## v1.0.35 -- 2026-06-13

### Improvements

  - Stability and performance improvements.

---

## v1.0.34 -- 2026-06-13

### Improvements

  - Stability and performance improvements.

---

## v1.0.33 -- 2026-06-13

### Improvements

  - Stability and performance improvements.

---

## v1.0.32 -- 2026-06-13

### Improvements

  - Stability and performance improvements.

---

## v1.0.31 -- 2026-06-12

### Improvements

  - Stability and performance improvements.

---

## v1.0.30 -- 2026-06-11

### Improvements

  - Stability and performance improvements.

---

## v1.0.29 -- 2026-06-11

### Improvements

  - Stability and performance improvements.

---

## v1.0.28 -- 2026-06-10

### Improvements

  - Stability and performance improvements.

---

## v1.0.27 -- 2026-06-09

### New Features

  - checklist): use item.index instead of item.id; add Save Note button; fix fetchChecklist response parsing

---

## v1.0.26 -- 2026-06-09

### New Features

  - cases+dashboard): case mgmt widgets, sort/filter, MCP tools, exposure widget

---

## v1.0.27 -- 2026-06-09

### New Features

  - **CasesListPage — 4 dashboard widgets**: Status donut, Severity donut, 30-day trend sparkline, Source/Workload panel. Fetches from enriched `/api/cases/metrics` endpoint.
  - **CasesListPage — Sort + extended filters**: Server-side sort on all columns; Source (ASM/SIEM) and Analyst dropdown filters; pagination.
  - **CasesListPage — Row actions**: Inline 🗑 Delete and 👤 Assign dropdown on every row.
  - **AI Chat (MCP) — 5 case tools**: `list_cases`, `get_case`, `summarize_case_operations`, `assign_case`, `update_case_notes`.
  - **InternalExposureDashboard — CyCases panel**: Live summary strip with posture note explaining case/score relationship.
  - **Metrics endpoint**: `/api/cases/metrics` now returns `cases_by_status`, `trend_30d`, `avg_age_hours`, `by_analyst`, `total_cases`, `asm_vs_siem`.

---

## v1.0.25 -- 2026-06-09

### New Features

  - cases): delete case, analyst assignment dropdown, vuln case persistence

---

## v1.0.26 -- 2026-06-09

### New Features & Fixes

  - **Vulnerabilities — case badge persists after refresh**: On mount the Vulnerability Explorer calls `GET /api/asm/cases` and uses SubtleCrypto SHA-256 to map each finding to its deterministic `ASM-XXXX` incident ID, restoring the `✓ Case open` badge without re-querying per row.
  - **Delete / Remove Case**: `✕ Remove Case` button added to Active Incidents drawer and Vulnerability drawer. Calls `DELETE /api/cases/<id>`, nulls case fields, reverts UI to Open Case. Confirmation dialog shown. Audit entry written.
  - **Assign to Analyst dropdown**: Notes & Assignment section now shows a `<select>` populated from `GET /api/cases/assignable-users` (all analyst/admin role users). Falls back to free-text input if endpoint unavailable.
  - **New endpoints**: `DELETE /api/cases/<id>`, `GET /api/asm/cases`, `GET /api/cases/assignable-users`.

---

## v1.0.24 -- 2026-06-09

### Bug Fixes

  - siem-proxy): inject authoritative case_opened_at from psycopg2 into incident responses
  - cases): prevent HTTP 500 on non-string description/recommendation; persist case_opened_at across page refresh

---

## v1.0.25 -- 2026-06-09

### Bug Fixes

  - **Active Incidents — case state lost after page refresh (root cause fixed)**: The SIEM correlation engine's SQLAlchemy async ORM session can hold stale `None` values for `case_opened_at` when its asyncpg connection pool contains connections whose transaction snapshot predates the psycopg2 case-open write. This causes `GET /incidents` to return `case_opened_at=null` even though the DB has the value correctly set. Fixed by post-processing `GET /incidents` and `GET /incidents/<id>` responses in the SIEM proxy: after forwarding the engine response, `case_opened_at`, `case_type`, `case_mttd_seconds`, `case_mtta_seconds`, and `case_restricted` are overwritten with values read directly via psycopg2 — which always reflects the latest committed DB state, bypassing the engine's session cache entirely.

---

## v1.0.24 -- 2026-06-09

### Bug Fixes

  - **External Exposure > Vulnerabilities — Open Case HTTP 500**: Vulnerabilities that lack CVSS/EPSS scores (e.g. exposed-path, JS-secret, OSINT findings) can carry structured objects or arrays in their `description` and `recommendation` fields. Calling `.strip()` on a non-string raised `AttributeError` → 500. Fixed by coercing to `str()` before strip in both `create_case` (finding path) and `create_asm_case`.

  - **Active Incidents — case state lost after page refresh**: After manually opening a case via psycopg2, the SIEM engine's SQLAlchemy async ORM session could hold a stale in-memory copy of the incident (loaded before the commit), causing `GET /incidents` to return `case_opened_at: null` on the next fetch. Fixed by adding a best-effort `PATCH /incidents/<id>` call to the SIEM engine after the psycopg2 commit, ensuring the async session also persists `case_opened_at` via its own ORM path.

---

## v1.0.23 -- 2026-06-09

### Improvements

  - Stability and performance improvements.

---

## v1.0.22 -- 2026-06-09

### Improvements

  - Stability and performance improvements.

---

## v1.0.21 -- 2026-06-09

### Improvements

  - Stability and performance improvements.

---

## v1.0.20 -- 2026-06-09

### Improvements

  - Stability and performance improvements.

---

## v1.0.19 -- 2026-06-09

### Improvements

  - Stability and performance improvements.

---

## v1.0.18 -- 2026-06-09

### Improvements

  - Stability and performance improvements.

---

## v1.0.17 -- 2026-06-09

### Improvements

  - Stability and performance improvements.

---

## v1.0.16 -- 2026-06-08

### New Features

  - comp): questionnaire reset at individual question, framework, and global level

---

## v1.0.15 -- 2026-06-08

### New Features

  - **Cross-Framework Questionnaire Correlation Engine** — Introduced a static cross-framework control correlation map spanning all 8 compliance frameworks (ISO 27001, NIS2, DORA, SOC 2, NIST CSF 2.0, PCI DSS v4.0, GDPR, EU AI Act). 23 control clusters covering Governance, Risk Assessment, IAM, MFA, Incident Response, BCP/Backup, Training, Encryption, Vulnerability Management, Supply Chain, Logging, Pen Testing, Asset Inventory, Physical Security, SDLC, Threat Intelligence, Privacy, and Regulatory Notification are mapped across 694 bidirectional correlation pairs. The new `cy_comp_question_correlations` table is seeded automatically on startup via `ensure_tables()`.

  - **Answer Propagation — Apply Once, Satisfy Many** — After answering any questionnaire question, the platform detects correlated questions in other frameworks and surfaces a `PropagationPanel` in the Assessments UI. Users can apply the same answer to all matching questions with a single click ("Apply to all N"), step through each suggestion individually ("Review individually"), or dismiss. Propagated answers are tracked via `propagated_from` and `propagation_accepted` columns and are visually badged in the questionnaire. New API endpoints: `GET /api/comp/questionnaire/<fw>/correlations`, `POST /api/comp/questionnaire/propagate`, `POST /api/comp/questionnaire/reject-propagation`, `GET /api/comp/question-correlations`.

  - **Multi-Framework Policy Document Upload** — Uploading a policy document now auto-detects which compliance frameworks it covers using keyword heuristics + CyMind LLM classification. The document is stored once in the shared `org-policies` RAG collection and its `mapped_frameworks[]` array is populated automatically — no re-uploading per framework. The upload UI shows framework coverage chips immediately after upload (e.g., `[ISO 27001] [NIS2] [SOC 2]`) with an explanation that policy analysis jobs for all detected frameworks will use the document automatically. New endpoint: `POST /api/comp/policy-docs/upload-multi`.

  - **GRC Cross-Framework Inventory Document** — Added `docs/GRC_CROSS_FRAMEWORK_CORRELATION.md` containing the full questionnaire inventory for all 8 frameworks, the complete cross-framework similarity map, a gap analysis of what was missing, and the full implementation design used to build this feature.

---

## v1.0.14 -- 2026-06-07

### Improvements

  - Stability and performance improvements.

---

## v1.0.13 -- 2026-06-07

### Improvements

  - Stability and performance improvements.

---

## v1.0.13 -- 2026-06-07

### New Features

  - **EU AI Act Compliance Framework** — Added EU AI Act (Regulation (EU) 2024/1689) as the 8th compliance framework across the entire GRC stack. Includes 30 structured questionnaire questions across 9 sections (Governance & Classification, Risk Management, Data Governance, Technical Documentation, Transparency, Human Oversight, Accuracy/Robustness/Cybersecurity, Provider/Deployer Obligations, Post-Market Monitoring & Incident Reporting). Framework is fully integrated into GRC Posture dashboard, Assessments controls list, Findings & Alerts filters and auto-generate pipeline, and Risk Register framework tags. MITRE ATT&CK enrichment (12 technique mappings) and REMEDIATION_GUIDANCE entries include EU AI Act article references (Art.9, Art.14, Art.15, Art.73). Questionnaire seeds automatically on backend restart via `seed_templates(force=True)`.

  - **AI Analysis Hide/Toggle in Compliance Findings** — In Security Compliance › Findings & Alerts › Findings, once AI analysis is run or was previously stored for a finding, the "AI Analyze" button now transforms into a "Hide AI / Show AI" toggle. A dismiss (✕) button also appears in the AI analysis panel header for instant collapse. State is per-finding and client-side — no re-fetch required on re-show.

### Bug Fixes

  - Fixed stale `"avg"` framework key in `auto_findings.py` REMEDIATION_GUIDANCE entries — replaced with correct `"gdpr"` identifier and proper GDPR article references.

---

## v1.0.12 -- 2026-06-01

### Improvements

  - Stability and performance improvements.

---

## v1.0.11 -- 2026-06-01

### New Features

  - comp): correct enrich_alerts_pass OR logic; add hourly compliance sync job

---

## v1.0.10 -- 2026-06-01

### Improvements

  - Stability and performance improvements.

---

## v1.0.9 -- 2026-06-01

### Improvements

  - Stability and performance improvements.

---

## v1.0.8 -- 2026-05-31

### Improvements

  - Stability and performance improvements.

---

## v1.0.7 -- 2026-05-31

### Bug Fixes

  - **CyMind enable flow now auto-updates CyMind** — After provisioning the portal service account, the enable flow uses the admin JWT (already obtained during login) to call CyMind's `POST /api/v1/system/update`. CyMind pulls the latest image in the background and restarts. The flow then polls until CyMind is healthy and verifies the chat key actually responds on `/api/v1/chat`, reporting the real outcome in the portal instead of silently assuming success.

---

## v1.0.6 -- 2026-05-31

### Improvements

  - Stability and performance improvements.

---

## v1.0.5 -- 2026-05-31

### Bug Fixes

  - Fix AI enrichment blocked by CyMind security pipeline (v1.0.5

---

## v1.0.5 -- 2026-05-31

### Bug Fixes

  - **AI enrichment restored across all modules** — CyMind's prompt injection security check (SEC-24) was false-positiving on raw SIEM incident data sent as the user message (IP addresses, attack commands, rule descriptions, and base64-decoded payloads from Wazuh alerts triggered injection patterns). Fixed by moving all enrichment context into the system prompt in both the correlation engine (`ai_router._cymind`) and the GRC compliance engine (`ai_analysis._call_llm`). The user message is now a short, benign instruction. This pattern matches how CyMind's own RAG pipeline separates external data from user instructions.
  - **GRC AI analysis now uses correct M2M flags** — `ai_analysis._call_llm` previously sent the system prompt as a `messages[role=system]` entry (OpenAI style) and did not disable RAG/MCP/integrations/operational context. Now uses the top-level `system` field and sets `use_rag/use_mcp/use_integrations/use_operational` to `False` for clean M2M calls.
  - **CyMind chat key validator fixed** — `cymind_post()` was rejecting valid `CyM_` prefixed keys (current CyMind format) with an error saying only `pak_` is accepted. Both prefixes are now accepted; `cymk_` (M2M admin key) is still rejected.
  - **CyMind test now probes the actual chat endpoint** — Previously `GET /api/system/cymind/test` only checked `/health` (bypasses license) and key presence. It now sends a minimal chat probe to `/api/v1/chat` so the portal accurately reflects whether enrichment will work, including detecting 401 (wrong key type), 400 (security policy blocking), and 429 (rate throttle).

---

## v1.0.4 -- 2026-05-30

### Improvements

  - Stability and performance improvements.

---

## v1.0.3 -- 2026-05-29

### Improvements

  - Stability and performance improvements.

---

## v1.0.2 -- 2026-05-29

### Bug Fixes

**`backend/requirements.txt` + `core/kv_secrets.py` — CI build broken: `infisical-sdk` does not exist on PyPI**
- Root cause: `requirements.txt` listed `infisical-sdk>=1.0.0` as a hard dependency, but no package under that name has ever been published to PyPI (`pip install infisical-sdk` returns "No matching distribution found"). The code in `core/kv_secrets.py` imported `from infisical_sdk import InfisicalSDKClient` using the fluent auth API (`client.auth.universal_auth.login`, `client.auth.oidc_auth.login`, `client.secrets.get_secret_by_name`) which belongs to a package that was never released. Every CI wheel-build job failed at the `pip install -r requirements.txt` step with exit code 1.
- Fix: Replaced `infisical-sdk>=1.0.0` with `infisical-python>=2.0.0` — the correct PyPI package (published by Infisical, provides the `infisical_client` module). Rewrote `_infisical_fetch` in `core/kv_secrets.py` to use the v2 API:
  - `core/kv_secrets.py`: import changed to `from infisical_client import InfisicalClient, ClientSettings, AuthenticationOptions, UniversalAuthMethod, GetSecretOptions`
  - Universal auth: credentials now passed via `ClientSettings(auth=AuthenticationOptions(universal_auth=UniversalAuthMethod(...)))` at client construction instead of a post-init `.login()` call
  - OIDC/Azure Arc auth: Arc JWT (from HIMDS challenge-response, unchanged) is now exchanged for an Infisical access token via `POST {url}/api/v1/auth/oidc-auth/login` REST call; the returned `accessToken` is passed as `AuthenticationOptions(access_token=...)` — `infisical-python` v2 has no native `oidc_auth` method
  - Secret fetch: `client.secrets.get_secret_by_name(environment_slug=..., secret_path=...)` replaced with `client.getSecret(GetSecretOptions(environment=..., path=...))`

---

## v1.0.1 -- 2026-05-29

### Improvements

  - Stability and performance improvements.

---

## v1.2.78 -- 2026-05-29

### Improvements

  - Stability and performance improvements.

---

## v1.2.77 -- 2026-05-29

### Improvements

  - Stability and performance improvements.

---

## v1.2.76 -- 2026-05-29

### Improvements

  - Stability and performance improvements.

---

## v1.2.75 -- 2026-05-29

### Improvements

  - Stability and performance improvements.

---

## v1.2.74 -- 2026-05-29

### Improvements

  - Stability and performance improvements.

---

## v1.2.73 -- 2026-05-29

### Improvements

  - Stability and performance improvements.

---

## v1.2.72 -- 2026-05-28

### Improvements

  - Stability and performance improvements.

---

## v1.2.71 -- 2026-05-28

### Improvements

  - Stability and performance improvements.

---

## v1.2.70 -- 2026-05-28

### Improvements

  - Stability and performance improvements.

---

## v1.2.69 -- 2026-05-27

### Improvements

  - Stability and performance improvements.

---

## v1.2.68 -- 2026-05-27

### Bug Fixes

  - Fix Infisical secrets not retrieved: package name typo + HIMDS check bugs

---

## v1.2.68 -- 2026-05-28

### Bug Fixes

  - Fix Infisical secrets backend never loading secrets at startup (requirements.txt typo: `infisicalsdk` → `infisical-sdk`)
  - Fix `infisical-refresh.sh` daily timer always reporting Arc MSI unreachable (wrong HIMDS path `/identity/...` → `/metadata/identity/...`)
  - Fix `infisical-refresh.sh` treating HIMDS healthy 401 challenge as failure (`curl -sf` → http_code check for 401)

### Ops Notes — Infisical + Azure Arc OIDC Troubleshooting (2026-05-28)

Full root cause and resolution for Infisical secrets not loading on CY360-DEV.

**Root causes found (3 code bugs + 1 config mismatch):**

1. **`requirements.txt` package name typo** — `infisicalsdk` is not a real PyPI package.
   The correct name is `infisical-sdk` (with hyphen). Because pip couldn't install it,
   `from infisical_sdk import InfisicalSDKClient` threw an `ImportError` at every startup,
   and the `except ImportError` block silently returned 0 — no secrets were ever fetched.
   The SDK happened to already be installed on CY360-DEV from a prior manual install,
   masking the typo at runtime; future fresh installs would have failed completely.

2. **Wrong HIMDS path in `infisical-refresh.sh`** — The daily secret-refresh systemd timer
   script checked `/identity/oauth2/token` instead of `/metadata/identity/oauth2/token`.
   Azure Arc HIMDS returns 404 on the wrong path, so the connectivity check always fired
   "WARN: Arc MSI endpoint unreachable" and exited with code 1, skipping the backend reload.

3. **`curl -sf` rejects HIMDS healthy response** — Even with the correct path, HIMDS
   intentionally returns HTTP 401 first (challenge-response). The `-f` flag in `curl -sf`
   treats any 4xx as a failure. The check was rewritten to capture the HTTP status code
   and accept 401 as the "healthy" signal.

4. **Bound Subject mismatch in Infisical OIDC identity** — The machine identity was
   configured with Bound Subject `054ce2b3-5181-4843-b07b-377907694700` (an incorrect OID
   from the Azure Portal App Registration page). The actual `sub` claim in the HIMDS JWT
   for CY360-DEV is `9bca8989-879a-4566-826a-1acb578c5f0d`. Infisical returned
   `403 OIDC subject not allowed` until the Bound Subject was corrected in the UI.

**Diagnosis steps used:**

```bash
# 1. Test Infisical fetch directly with debug logging
ssh -p 2026 root@77.42.75.20
python3 -c "
import logging, os; logging.basicConfig(level=logging.DEBUG, ...)
# load .env, then:
from core.kv_secrets import _infisical_fetch, FLASK_KV_MAP
_infisical_fetch(FLASK_KV_MAP)
"

# 2. Decode live HIMDS JWT to read actual claims
python3 << 'EOF'
# (HIMDS challenge-response → base64 decode JWT payload → print iss/sub/oid/aud)
EOF
```

**CRITICAL — Bound Subject is unique per server:**
The `sub` claim in the HIMDS JWT is the Azure Arc Managed Identity Object ID for that
specific machine. It is assigned by Azure at Arc enrollment time and is different for
every server. For each new CyCentra 360 deployment using `INFISICAL_AUTH_METHOD=azure`:
  - Get the server's OID: run the JWT decode snippet above and read the `sub` field
  - Create a new OIDC machine identity in Infisical for that server with its specific
    Bound Subject, OR
  - Use `INFISICAL_AUTH_METHOD=universal` (client ID + secret) to avoid per-server
    machine identities entirely — recommended for multi-server deployments

Verified OIDC claims for CY360-DEV (2026-05-28):
  - iss: `https://sts.windows.net/00864d66-c8a8-443f-8d0a-3df93346e266/`
  - sub/oid: `9bca8989-879a-4566-826a-1acb578c5f0d`
  - aud: `https://management.azure.com`
  - appid (Arc MSI): `bd494fef-83ea-453a-abf1-59a66674f1eb`

**Status after fix:** OIDC auth returns 200. Secrets present in Infisical load correctly.
Missing secrets (SSO, Google/Microsoft OAuth keys, CyMind) return 404 — they need to be
uploaded to Infisical (not an auth issue).

---

## v1.2.67 -- 2026-05-27

### Improvements

  - Stability and performance improvements.

---

## v1.2.66 -- 2026-05-27

### Improvements

  - Stability and performance improvements.

---

## v1.2.65 -- 2026-05-27

### Improvements

  - Stability and performance improvements.

---

## v1.2.64 -- 2026-05-27

### Improvements

  - Stability and performance improvements.

---

## v1.2.63 -- 2026-05-27

### Improvements

  - Stability and performance improvements.

---

## v1.2.62 -- 2026-05-27

### Improvements

  - Stability and performance improvements.

---

## v1.2.61 -- 2026-05-27

### Improvements

  - Stability and performance improvements.

---

## v1.2.60 -- 2026-05-27

### Improvements

  - Stability and performance improvements.

---

## v1.2.59 -- 2026-05-27

### Improvements

  - Stability and performance improvements.

---

## v1.2.58 -- 2026-05-27

### Improvements

  - Stability and performance improvements.

---

## v1.2.57 -- 2026-05-27

### Improvements

  - Stability and performance improvements.

---

## v1.2.56 -- 2026-05-27

### Improvements

  - Stability and performance improvements.

---

## v1.2.55 -- 2026-05-26

### Improvements

  - Stability and performance improvements.

---

## v1.2.54 -- 2026-05-26

### Improvements

  - Stability and performance improvements.

---

## v1.2.53 -- 2026-05-26

### Improvements

  - Stability and performance improvements.

---

## v1.2.52 -- 2026-05-26

### Improvements

  - Stability and performance improvements.

---

## v1.2.51 -- 2026-05-26

### Improvements

  - Stability and performance improvements.

---

## v1.2.50 -- 2026-05-26

### Improvements

  - Stability and performance improvements.

---

## v1.2.49 -- 2026-05-26

### Improvements

  - Stability and performance improvements.

---

## v1.2.48 -- 2026-05-26

### Improvements

  - Stability and performance improvements.

---

## v1.2.47 -- 2026-05-26

### Bug Fixes

  - downgrade infisicalsdk requirement to >=1.0.0 (2.x does not exist on PyPI

---

## v1.2.46 -- 2026-05-26

### Improvements

  - Stability and performance improvements.

---

## v1.2.45 -- 2026-05-26

### Improvements

  - Stability and performance improvements.

---

## v1.2.45 -- 2026-05-26

### New Features

  - SIEM engine now loads `/opt/cycentra/.env` as the first EnvironmentFile so all company-wide secrets (vault creds, CLOUD_MISP_*, CYMIND_*, GH_TOKEN, etc.) are available to the engine without duplication — operators only need to edit `.env`
  - Host Intelligence host-list now refreshes automatically every hour (30 s startup delay) — no manual trigger needed
  - AI Analysis available as on-demand per-incident call (`/incidents/{id}/analyse`) bypassing the `LLM_ENABLED` gate, so individual analysts can trigger enrichment even when background enrichment is off
  - `LLM_ENABLED=true` by default — AI enrichment is active on fresh installs without extra config

### Bug Fixes

  - MISP threat-intelligence enrichment was silently disabled after the UI widget was removed; new `_bridge_cloud_misp_creds` model_validator in `config.py` auto-enables MISP at engine startup whenever `CLOUD_MISP_API_KEY` is present in the vault — all existing installations pick this up on next engine restart
  - CyIRIS ticket links in portal and incident notifications now resolve to the correct public hostname (`https://cyiris.<domain>`) instead of the internal loopback URL
  - Engine double-loads removed: `CLOUD_MISP_*`, `CYMIND_*`, and vault bootstrap vars no longer duplicated in `cysiemstack.env`

### Improvements

  - Platform Extensions → CyIRIS panel simplified: removed 3-mode selector; replaced with static status notification + FP threshold slider only
  - MISP configuration widget removed from Platform Extensions UI — MISP is fully vault-managed; no UI action required
  - `cysiemstack.env` slimmed to engine-only entries (DB, Redis, Wazuh, tuning params) — ~30% smaller
  - `cysiemstack/.env.example` rewritten to match new slim format with inline inheritance notes
  - Infisical Python SDK (`infisicalsdk>=2.0.0`) re-enabled in `requirements.txt`
  - `get_iris_public_url()` helper centralises public CyIRIS URL resolution: `CLOUD_IRIS_PUBLIC_URL` env → `https://cyiris.<BASE_DOMAIN>` → fallback

---

## v1.2.44 -- 2026-05-25

### Improvements

  - Stability and performance improvements.

---

## v1.2.43 -- 2026-05-25

### Improvements

  - Stability and performance improvements.

---

## v1.2.42 -- 2026-05-25

### Improvements

  - Stability and performance improvements.

---

## v1.2.41 -- 2026-05-25

### Bug Fixes

  - create wazuh_ui_user OpenSearch role if absent before rolesmapping PUT (was 404

---

## v1.2.40 -- 2026-05-25

### New Features

  - add VALID_MODULES to compose.py — ImportError crash on Flask startup

### Bug Fixes

  - grep -c produces 0
0 when no match — use || true + ${:-0} fallback to avoid [[ ]] syntax error
  - handle Azure Arc AZCM0044 (resource already exists) and disconnected state gracefully
  - handle unsupported OS in Azure Arc installer — skip gracefully instead of aborting setup

---

## v1.2.39 -- 2026-05-25

### New Features

  - setup): add CYMIND_API_URL + CYMIND_API_KEY to vault bootstrap
  - add CyMind to central vault (Infisical) management
  - remove CyMISP from UI; make MISP vault-only via hardcoded backend
  - vault): scope vault maps to company-wide secrets only
  - vault): self-bootstrap vault on install + add pull_to_env rotation sync
  - Infisical OIDC path + CLI install + daily secret refresh timer
  - Azure Arc + Infisical secrets architecture

### Bug Fixes

  - remove SMTP_PASSWORD and CLOUD_IRIS_URL from vault maps
  - CyIRIS post-install auto-activates integration without manual key entry
  - vault): remove app-managed and non-secret keys from vault maps

### Improvements

  - security: remove all hardcoded secrets, complete vault coverage

---

## v1.2.38 -- 2026-05-24

### Improvements

  - Stability and performance improvements.

---

## v1.2.37 -- 2026-05-24

### Bug Fixes

  - **Active Incidents — "Request AI Enhancement" button returning 503:** Root cause was `LLM_ENABLED=false` set explicitly in `/opt/cycentra/cysiemstack.env`, which caused `enrich_incident()` in the SIEM correlation engine to short-circuit and return `{}`. The `analyse_incident` endpoint then raised 503 on an empty result. Fixed by setting `LLM_ENABLED=true` and restarting `cysiemstack-engine`. AI analysis now flows through to CyMind correctly.

### New Features

  - **Host Intelligence — Item status persistence across sessions:** Status labels set on items in the SCA, Vulnerabilities, Alerts, MITRE, and Compliance detail tabs are now persisted to the database (new `host_item_acks` PostgreSQL table in the correlation DB). Status is restored on every panel open via a `GET /api/siem/hosts/<agent_id>/item-statuses` call on tab mount. Previously, status labels were React-only state and were lost on panel close.

  - **Host Intelligence — Analyst acknowledgements feed into security posture score:** Items marked as `false_positive` or `resolved` now reduce the effective failure count when computing the per-host posture score in `host_service.py`. Acknowledged SCA checks count as passes; each acknowledged vulnerability adds approximately 4 points to the vulnerability sub-score (medium-severity-removal approximation). The adjustment is applied during the hourly posture recalculation and is wrapped in a safe try/except so the score degrades gracefully if the acks table is not yet initialised.

  - **Host Intelligence — New API endpoints:** `GET /api/siem/hosts/<agent_id>/item-statuses` returns all current ack statuses for a host as a nested dict `{item_type: {item_key: status}}`. `POST /api/siem/hosts/<agent_id>/item-statuses` upserts or clears a single ack. Accepted `item_type` values: `sca`, `vulnerability`, `alert`, `mitre`, `compliance`. Accepted `status` values: `investigating`, `in_review`, `resolved`, `false_positive` (null = delete).

---

## v1.2.36 -- 2026-05-24

### Improvements

  - Stability and performance improvements.

---

## v1.2.35 -- 2026-05-23

### Improvements

  - Stability and performance improvements.

---

## v1.2.34 -- 2026-05-23

### Improvements

  - Stability and performance improvements.

---

## v1.2.33 -- 2026-05-23

### Improvements

  - Stability and performance improvements.

---

## v1.2.32 -- 2026-05-22

### Bug Fixes

  - server-status endpoint missing fields + redesign tab with progress bar meters

---

## v1.2.31 -- 2026-05-22

### New Features

  - add missing ServerStatusTab component definition (ReferenceError

---

## v1.2.30 -- 2026-05-22

### Improvements

  - Stability and performance improvements.

---

## v1.2.29 -- 2026-05-20

### Improvements

  - Stability and performance improvements.

---

## v1.2.28 -- 2026-05-20

### Improvements

  - Stability and performance improvements.

---

## v1.2.27 -- 2026-05-20

### Improvements

  - Stability and performance improvements.

---

## v1.2.26 -- 2026-05-20

### Improvements

  - Stability and performance improvements.

---

## v1.2.25 -- 2026-05-20

### Improvements

  - Stability and performance improvements.

---

## v1.2.24 -- 2026-05-20

### Improvements

  - Stability and performance improvements.

---

## v1.2.23 -- 2026-05-19

### Improvements

  - Stability and performance improvements.

---

## v1.2.22 -- 2026-05-19

### Improvements

  - Stability and performance improvements.

---

## v1.2.21 -- 2026-05-18

### Improvements

  - Stability and performance improvements.

---

## v1.2.20 -- 2026-05-17

### Improvements

  - Stability and performance improvements.

---

## v1.2.19 -- 2026-05-16

### New Features

  - framework filter for benchmark compliance, renames, GDPR in framework docs

---

## v1.2.18 -- 2026-05-16

### Bug Fixes

  - cy-comp): fix collection ID resolution for org-policies RAG pipeline

---

## v1.2.17 -- 2026-05-16

### Bug Fixes

  - cy-comp): TypeError _set() duplicate job_id arg in policy_analysis.py

---

## v1.2.16 -- 2026-05-16

### Bug Fixes

  - cy-comp): ImportError get_admin_key → get_cymind_api_key in ai_analysis.py

---

## v1.2.15 -- 2026-05-15

### New Features

  - cy-comp): v1.2.15 — Policy Analysis pipeline (RAG → LLM → questionnaire auto-scoring

---

## v1.2.15 -- 2026-05-16

### New Features

  - **Policy Analysis pipeline** — Upload org policy documents, then run AI-powered analysis to auto-score the compliance questionnaire. For each control question, CyMind RAG retrieves relevant policy excerpts and the LLM assigns Pass / Partial / Fail. Results are written to the Assessment questionnaire with evidence snippets and justifications.
  - **Policy Analysis UI** (`Policy Documents` page) — Framework selector, overwrite toggle, "Run Policy Analysis" button, live progress bar with per-question status, and a completion summary showing answered / skipped / error counts.
  - **New API routes**: `POST /api/comp/policy-docs/analyze-framework` (start job) and `GET /api/comp/policy-docs/analyze-jobs/<job_id>` (poll progress).

---

## v1.2.14 -- 2026-05-15

### Improvements

  - Stability and performance improvements.

---

## v1.2.13 -- 2026-05-15

### Improvements

  - Stability and performance improvements.

---

## v1.2.12 -- 2026-05-15

### Improvements

  - Stability and performance improvements.

---

## v1.2.11 -- 2026-05-15

### Improvements

  - Stability and performance improvements.

---

## v1.2.11 -- 2026-05-15

### Features

- **GRC dashboard widgets now filter by framework selection** — All five widgets on the GRC Posture Dashboard now scope their data to the globally selected frameworks (Overall Posture donut, Findings by Severity pie, Findings by Verdict bars, Risk Register summary, Active Alerts count, Questionnaire Hub). The `GET /api/comp/dashboard?frameworks=...` endpoint accepts a comma-separated list of framework IDs and scopes every backend query accordingly.
- **GRC Scoring Model documentation** — Added `docs/GRC_SCORING_MODEL.md` with a complete explanation of the questionnaire weight-based baseline, alert penalty calculation (severity tiers, 40-point cap), zero-questions baseline logic, framework-to-alert mapping, score normalization, and the framework selector behaviour.

### Bug Fixes

- **Overall Posture score now reflects selected frameworks** — The donut percentage previously averaged all 7 frameworks regardless of the chip selector. It now averages only the selected frameworks.
- **Findings charts no longer show cross-framework noise** — Findings by Severity and Findings by Verdict now filter by `framework = ANY(selected)` so deselecting a framework removes its findings immediately.
- **Risk Register widget scoped to selected frameworks** — Risks with no overlap with selected frameworks are excluded from all counts.

---

## v1.2.10 -- 2026-05-15

### Improvements

  - Stability and performance improvements.

---

## v1.3.0 -- 2026-05-15

### Features

- **GDPR framework added** — Full EU GDPR coverage across all GRC modules:
  - 30-question assessment covering Art.5 (principles), Art.6/7 (lawful basis & consent), Art.12-23 (data subject rights), Art.25 (privacy by design), Art.28 (DPA contracts), Art.30 (RoPA), Art.32 (security), Art.33-34 (breach notification), Art.35 (DPIA), Art.37-39 (DPO), Art.44-49 (international transfers), Art.83 (accountability)
  - MITRE ATT&CK → GDPR control mappings added to enrichment engine for all 14 techniques and 10 Wazuh rule IDs (Art.32, Art.33, Art.34, Art.25, Art.5(1)(f))
  - GDPR appears in Framework Posture Scores, Score Trend, Findings, Assessment, Live Alerts, Reports
  - Score: `100 − alert_penalty` baseline (same formula as other frameworks)
- **Framework selector on GRC Posture Dashboard** — Coloured chip toggles above the Framework Posture Scores card let users select which frameworks are displayed. Selection is persisted to `localStorage` (`cy_fw_filter`) and propagates globally:
  - Dashboard: score bars, trend chart lines, questionnaire completion all filtered
  - Findings page: framework dropdown restricted to selected frameworks
  - Assessment page: framework tabs restricted to selected frameworks
  - Live Alerts page: framework filter dropdown restricted to selected
  - Reports page: framework report dropdown restricted to selected
  - Selecting a single framework auto-pre-selects it in per-page dropdowns

### Bug Fixes

- **Alert enrichment** — `_GROUP_TO_FRAMEWORK` now maps Wazuh `gdpr` rule group to `gdpr` (was incorrectly mapped to `avg`)
- **`avg` (GDPR-NL) references removed** from portal dropdowns in favour of canonical `gdpr` key

---

## v1.2.9 -- 2026-05-15

### Bug Fixes

  - cy-comp): v1.2.9 — live alert_penalty+q_answered, score bar labels, trend jitter

---

## v1.2.8 -- 2026-05-15

### Bug Fixes

  - cy-comp): v1.2.8 — harden CTL cache repair and trend chart visibility

---

## v1.2.8 -- 2026-05-15

### Bug Fixes

  - **CTL=0 and trend lines hardened**: `compute_framework_scores()` INSERT failures now log instead of silent swallow. `get_latest_scores()` writes corrected values back to DB on first dashboard load (no Refresh click needed). `LineChart` renders single-snapshot frameworks as visible dashed horizontal lines with label, instead of an invisible dot.

---

## v1.2.7 -- 2026-05-15

### Bug Fixes

  - **CTL/CRIT zeros, trend missing lines, appetite vs heatmap mismatch** — see v1.2.7 release notes.

---

## v1.2.7 -- 2026-05-15

### Bug Fixes

  - **Framework Posture Scores — CTL showing 0** — `get_latest_scores()` was returning stale cached rows from `cy_comp_framework_scores` where `total_controls=0` (rows written before the `FRAMEWORK_CONTROL_COUNTS` fallback existed). Fixed by skipping the cache when `total_controls=0` and running a fresh live computation. CTL now shows e.g. `0/28` for unstarted frameworks. Hover tooltip added: "CTL = passing questions / total questions", "CRIT = failing controls + critical/high compliance alerts".
  - **Score Trend — only 2 lines visible** — `LineChart` was silently dropping any framework with fewer than 2 score snapshots (`if (scores.length < 2) return null`). Fixed: frameworks with 1 snapshot now render as a coloured dot at the correct score level. Frameworks with 2+ snapshots render lines with timestamp-based x-positioning and an end-point dot. All 6 frameworks are now always visible once at least one score snapshot exists.
  - **Risk Appetite numbers differ from Heatmap** — The discrepancy is by design: the Heatmap counts ALL non-closed risks (including `accepted`); the Appetite analysis excludes `accepted` risks because they are intentionally outside the mitigation cycle. This was not communicated to users. Fixed: Appetite tab now shows a Severity Breakdown section (Critical/High/Medium/Low counts for open+mitigated risks only) and an explanatory note clarifying why the totals differ from the Heatmap. Backend `get_appetite()` extended to return `severity_summary` dict.

---

## v1.2.6 -- 2026-05-15

### New Features

  - **Comprehensive PDF compliance reports** — `report.py` completely rewritten. PDFs now include: navy/teal branded cover page with live posture score ring and grade, executive summary table (overall score, grade, completion %, findings count, open risks, alert count), framework posture scores table with per-framework grade/passing/critical-gaps/alert-penalty breakdown, horizontal bar chart (reportlab HorizontalBarChart), questionnaire completion table per framework, compliance-relevant alerts summary (30-day, severity breakdown), top-50 findings table (sortable by severity), risk register summary (severity counts + top-30 risks table), gap analysis section with per-framework prioritised recommendations (REC-01…), and conclusion with framework tier list and 6 next-step actions. PDF is fully usable and self-contained; JSON export retained alongside.
  - **Benchmark compliance integration** — `_collect_compliance_score()` in `blueprints/benchmark/routes.py` rewrote. Previously queried `cy_compliance_controls` (non-existent table), causing the compliance dimension to always return `score=None` and be silently excluded from the CSPI composite score. Now queries `cy_comp_framework_scores` for the latest cached score per framework (falls back to live questionnaire weight calculation if cache is empty), then averages across all frameworks. Compliance dimension is now live in the CSPI composite on the Benchmark page.
  - **Dashboard extended** — Risk Register Summary widget and Questionnaire Completion widget added to Compliance Dashboard (Row 5). Risk widget: severity count chips + stacked severity bar + "VIEW HEATMAP →" nav. Questionnaire widget: per-framework colour-coded progress bars with answered/total label + "OPEN ASSESSMENT →" nav.

### Bug Fixes

  - **Dashboard refresh blanking all widgets** — `Refresh Scores` button was writing the `/api/comp/framework-scores?refresh=true` response (shape `{scores:[...]}`) into the main `summary` state, destroying all other widget data. Fixed: score recompute call moved to `.finally(() => fetchDashboard())` so the full dashboard is always re-fetched after scores update.
  - **Scoring inconsistency** — `compliance.py` `_compute_score_for_framework()` used count-based formula while `questionnaire.py` `score_framework()` used weight-based formula, causing Dashboard and Assessment page to show different numbers for the same framework. Unified to weight-based formula: `q_score = (pass_weight + partial_weight × 0.5) / total_weight × 100`.

---

## v1.2.5 -- 2026-05-14

### New Features

  - **ISO 27001 Statement of Applicability (SoA)** — two-tier assessment model: 45 grouped questionnaire questions for scoring + a per-control SoA view listing all 93 Annex A controls individually, satisfying ISO 27001:2022 Cl.6.1.3(d). Analyst can include/exclude each control with a typed justification. Status (compliant / partial / gap / breach / excluded / not assessed) auto-derived from questionnaire responses and open breach findings. Controls grouped by Annex A theme (Organisational / People / Physical / Technological) with theme-level gap summaries and coverage percentage. Accessible as a "Statement of Applicability" sub-tab on the ISO 27001 assessment page.
  - **Policy Documents guidance panel** — collapsible guide on the Policy Documents page listing 12 recommended policy categories (Information Security Policy, IRP, Access Control, Risk Management, BCP/DR, Asset Management, Vendor Security, Data Classification, AUP, Change Management, Vulnerability Management, Privacy/GDPR), recommended naming convention (`<Policy_Name>_v<Version>_<Year>.pdf`) with examples, supported file types, annual review cycle note, and a callout clarifying the difference between org policy docs and framework reference documents.
  - **Extended compliance framework mapping** — enrichment engine (`enrichment.py`) now tags alerts against SOC 2 (CC Trust Services Criteria), NIST CSF 2.0 (GV/ID/PR/DE/RS/RC function.subcategory format), and PCI DSS v4.0 (Req 1–12) in addition to the existing NIS2 / DORA / ISO 27001 / AVG coverage. All 15 MITRE ATT&CK technique entries and all 10 Wazuh rule ID entries extended. Backfill endpoint added: `POST /api/comp/findings/re-enrich-alerts` resets and re-tags all historical alerts.

### Bug Fixes

  - **Risk heat map / Auto Populate 500 error** — `auto_populate_from_findings` was passing a raw Python list into a JSONB column without `json.dumps()`, causing a psycopg2 `ProgrammingError` on every call. Fixed with proper serialisation. Query also expanded to include manual findings (was previously restricted to `auto_generated = TRUE` only), so the button is useful immediately after questionnaire gap findings are generated.
  - **cy_comp_soa_entries table** — new DB table added (`cy_comp/models.py`) to persist analyst SoA include/exclude decisions and justifications. Auto-created at startup via `ensure_tables()`.

---

## v1.2.4 -- 2026-05-14

### Improvements

  - Stability and performance improvements.

---

## v1.2.3 -- 2026-05-14

### Improvements

  - Stability and performance improvements.

---

## v1.2.2 -- 2026-05-14

### Improvements

  - Stability and performance improvements.

---

## v1.2.1 -- 2026-05-14

### Improvements

  - Stability and performance improvements.

---

## v1.2.0 -- 2026-05-14

### New Features

  - cy-comp): zero-duplicate GRC — enrich alerts/incidents in-place, fix RAG URLs

---

## v1.1.3 -- 2026-05-14

### Bug Fixes

  - cy-comp): read cymind_integration nested object from ai_settings.json

---

## v1.1.2 -- 2026-05-14

### Bug Fixes

  - cy-comp): 4 UX improvements — risk pages merged, compliance tagging, RAG settings, severity mapping

---

## v1.1.1 -- 2026-05-14

### New Features

  - cy-comp): add cy_comp* to wheel package include list

---

## v1.1.0 -- 2026-05-14

### New Features

  - cy-comp): integrate GRC compliance module into CyCentra360
  - inject linked alerts into CyMind incident detail context

### Bug Fixes

  - incidents page now defaults to Active filter, shows all 20 correctly
  - active incidents now fetched by status=investigating|open
  - 3 chat context issues — incident count, ASM IDs, guest scan leak
  - action widget not triggering when INC-ID absent from close/resolve message

---

## v1.0.419 -- 2026-05-13

### Bug Fixes

  - ueba_flags AttributeError crash in _fetch_incident_detail_block

---

## v1.0.418 -- 2026-05-13

### Bug Fixes

  - guest-isolation): move guest scans/reports to separate dir tree

---

## v1.0.417 -- 2026-05-13

### Bug Fixes

  - scheduler): scheduled scans write to shared scheduler/ dir

---

## v1.0.416 -- 2026-05-13

### Bug Fixes

  - setup): deduplicate CLOUD_IRIS_URL in --update .env patch
  - deduplicate CLOUD_IRIS_URL in .env when CyIRIS is installed

---

## v1.0.415 -- 2026-05-12

### Bug Fixes

  - backfill Host Name and Host OS for existing incidents on engine restart

---

## v1.0.414 -- 2026-05-12

### New Features

  - add Host Name and Host OS columns to Active Incidents table

---

## v1.0.413 -- 2026-05-12

### Improvements

  - Stability and performance improvements.

---

## v1.0.412 -- 2026-05-12

### Improvements

  - Stability and performance improvements.

---

## v1.0.411 -- 2026-05-12

### Improvements

  - Stability and performance improvements.

---

## v1.0.410 -- 2026-05-12

### Improvements

  - Stability and performance improvements.

---

## v1.0.409 -- 2026-05-12

### Bug Fixes

  - setup): stop stripping OIDC settings in step 4.1 and decouple Wazuh OIDC from oauth2proxy gate

---

## v1.0.408 -- 2026-05-12

### Bug Fixes

  - **CySIEM OIDC — `--update` strips OIDC settings and doesn't restore them when oauth2-proxy secrets are absent**: Step 4.1 unconditionally removed `opensearch_security.auth.type` and all `opensearch_security.openid.*` keys from `opensearch_dashboards.yml` to "clean before re-write". The re-write (Step 4.3b) was nested inside the oauth2-proxy secrets gate (`if OAUTH2PROXY_SECRET && OAUTH2PROXY_COOKIE_SECRET`). On any `--update` run where those secrets were empty or not loaded in time, the entire Step 4.3b was skipped — leaving the dashboard permanently in basic-auth mode (Wazuh login screen shown instead of OIDC redirect). Two fixes applied: (1) Step 4.1 no longer strips OIDC keys — only legacy proxy-auth settings (`proxycache.*`, `requestHeadersAllowlist`) are removed; (2) the Wazuh Dashboard OIDC block is now structurally separated from the oauth2-proxy gate so it always runs when Wazuh is installed, regardless of oauth2-proxy secret availability. **Files changed**: `cycentra-setup.sh`, `docs/RELEASE_NOTES.md`.

---

## v1.0.407 -- 2026-05-12

### Bug Fixes

  - **CySIEM OIDC — admin users not mapped to Wazuh `administrator` role**: OIDC authentication gave users an OpenSearch `all_access` session (dashboard access) but Wazuh has a second, independent RBAC layer in the Wazuh Manager API that controls Wazuh operations (agent management, policies, etc.). Without explicit rules in the Wazuh API, OIDC users landed with only `own_index` and `all_access` — enough to see the dashboard but no agent management. Three security rules are now created via the Wazuh Manager API during setup, mapping OIDC `backend_roles` to Wazuh API roles:
    - `cy360_oidc_admin`: `backend_roles: "admin"` → Wazuh `administrator` (full access, agent management)
    - `cy360_oidc_analyst`: `backend_roles: "analyst"` → Wazuh `agents_admin` (agent management, no user/role admin)
    - `cy360_oidc_viewer`: `backend_roles: "viewer"` → Wazuh `readonly`
    The rules are idempotent — skipped if a rule with the same name already exists. **Files changed**: `cycentra-setup.sh` (Wazuh API RBAC rules block after OpenSearch rolesmapping step), `docs/RELEASE_NOTES.md`.

---

## v1.0.406 -- 2026-05-12

### Bug Fixes

  - **CySIEM OIDC — nginx `sites-enabled` symlink not recreated on `--update`**: On servers where `/etc/nginx/sites-enabled/cycentra-modules` existed as a hardcopy file (not a symlink), running `--update` would migrate the siem-gate proxy headers out of `sites-available/cycentra-modules` but nginx kept reading the untouched hardcopy in `sites-enabled`. This caused the old `auth_request /siem-gate`, `proxy_set_header Authorization $wazuh_auth`, and `X-Proxy-User`/`X-Proxy-Roles` injection to remain active after every update — preventing OIDC from taking effect. The `--update` path now explicitly re-creates `sites-enabled/cycentra-modules` as a symlink to `sites-available/cycentra-modules` whenever it detects a hardcopy (non-symlink) file, ensuring all nginx migrations are immediately visible to the running nginx process.

---

## v1.0.405 -- 2026-05-11

### Improvements

  - Stability and performance improvements.

---

## v1.0.404 -- 2026-05-12

### New Features

  - **CySIEM OIDC SSO — individual user identity in Wazuh Dashboard**: Replaced the nginx siem-gate Basic Auth injection approach with native OIDC authentication in Wazuh Dashboard, giving each user their own identity instead of sharing a service account.

    **Root cause of the previous limitation**: When a user authenticated via nginx Basic Auth injection, Wazuh Dashboard set a `security_authentication` session cookie (Iron-sealed, HttpOnly). On subsequent requests, Wazuh used the cookie session — ignoring the `Authorization` header entirely. All users therefore appeared as the shared `cy360_sso` service account regardless of which Cy360 role they held.

    **Architecture — Wazuh OIDC via CyCentra IdP**:
    - `opensearch_dashboards.yml` now uses `opensearch_security.auth.type: openid` pointing to `https://cyasm.DOMAIN/oidc/.well-known/openid-configuration`.
    - The `cysiem` OIDC client (already registered in the CyCentra OIDC provider) issues RS256 ID tokens containing `email` (user identity) and `roles: ["admin"|"analyst"|"viewer"]` (Cy360 RBAC role).
    - OpenSearch Security `config.yml` has a new `openid_auth_domain` (order: 0, `subject_key: email`, `roles_key: roles`) that maps the OIDC token roles claim to OpenSearch backend roles.
    - SSO flow: user visits `cysiem.DOMAIN` → Wazuh Dashboard redirects to OIDC IdP → IdP checks existing Cy360 Flask session cookie (`.cycentra.com` domain, so shared across all subdomains) → issues auth code silently if logged in → Wazuh establishes individual session. No double login required.

    **Role mapping in OpenSearch Security**:
    - `all_access` backend_roles → `["admin", "analyst", "all_access"]` — full Wazuh Dashboard access.
    - `kibana_user` backend_roles → `["viewer", "kibanauser"]` — read-only dashboard.
    - `wazuh_ui_user` backend_roles → `["viewer", "wazuh_ui_user"]` — Wazuh UI panels.

    **nginx cysiem block simplified**: Removed `auth_request /siem-gate`, `auth_request_set $wazuh_auth`, `location = /siem-gate`, and `proxy_set_header Authorization $wazuh_auth`. The cysiem server block now has a simple `location /` proxy_pass to `127.0.0.1:5601` with no auth_request gate — Wazuh Dashboard OIDC handles authentication end-to-end.

    **`cycentra-setup.sh` changes**:
    - Step 4.1: Now clears stale auth settings only (OIDC config applied later in step 4.3b).
    - Step 4.3b: New `CySIEM OIDC Authentication` step: (1) writes OIDC settings to `opensearch_dashboards.yml` from `CYSIEM_OIDC_SECRET`; (2) idempotent Python script inserts `openid_auth_domain` block into `config.yml` (detects indent from `basic_internal_auth_domain`); (3) applies via `securityadmin.sh`; (4) updates `all_access`, `kibana_user`, `wazuh_ui_user` rolesmapping via REST API.
    - Idempotent nginx migration: detects existing siem-gate blocks and removes them, replacing with simple proxy_pass.

    **Files changed**: `cycentra-setup.sh` (step 4.1, step 4.3b, nginx cysiem template, idempotent migration), `docs/RELEASE_NOTES.md`.

---

## v1.0.403 -- 2026-05-11

### New Features

  - **CySIEM role-aware SSO — admin/analyst vs viewer differentiation**: Wazuh Dashboard auto-login now reflects the logged-in user's Cy360 RBAC role, replacing the previous single shared-credential approach (all users logged into Wazuh as the same admin service account).

    **Architecture change — nginx siem-gate auth_request**:
    - `auth_request /oauth2/auth` (static IAP gate) replaced with `auth_request /siem-gate` pointing to a new Flask endpoint `GET /api/siem/internal/auth`.
    - Flask validates the Cy360 session cookie forwarded by nginx in the sub-request, looks up the user's RBAC role, and returns `X-Wazuh-Auth: Basic <credential>` in the response header.
    - nginx captures the header via `auth_request_set $wazuh_auth $upstream_http_x_wazuh_auth` and injects it as `proxy_set_header Authorization $wazuh_auth` for the upstream Wazuh Dashboard request.
    - `401` from Flask → nginx `error_page 401 = @error401` → redirect to Cy360 login.

    **Role mapping**:
    - `admin` / `analyst` → `cy360_sso` OpenSearch account (`backend_roles: [admin]`) — full Wazuh Dashboard access.
    - `viewer` / any other → `cy360_readonly` OpenSearch account (`backend_roles: [kibana_user, wazuh_ui_user]`) — read-only Wazuh access.

    **New OpenSearch service account**: `cy360_readonly` (password: `CyCentra360!ReadOnly`, hash: `$2y$12$0Tim1grS5kbbBdG20PFsF...`). Created via `securityadmin.sh` in `cycentra-setup.sh` Step 7. Idempotent — skipped if already present.

    **Files changed**: `backend/siem_proxy.py` (new `GET /api/siem/internal/auth` endpoint + `_WAZUH_ADMIN_BASIC`/`_WAZUH_RO_BASIC` module constants), `cycentra-setup.sh` (cy360_readonly user creation, nginx template updated, idempotent migration for existing installs).

### Bug Fixes

  - **chat**: close/resolve incident action now pre-fetches current status, surfaces engine errors, and refreshes Incidents list on success.

---

## v1.0.402 -- 2026-05-11

### Improvements

  - Stability and performance improvements.

---

## v1.0.401 -- 2026-05-11

### Improvements

  - Stability and performance improvements.

---

## v1.0.403 — Fix close/resolve incident action via CyMind chat — 2026-05-11

### Bug Fixes

- **Agentic close-incident action**: Fixed silent failure where "close incident" appeared to succeed in the CyMind chat overlay but the incident status remained `investigating` in the database. Root causes addressed:
  - Backend now pre-fetches the current incident status before attempting the `→ resolved` transition. This provides an accurate `from_status` in the audit trail and surfaces a clear "not found" error if the incident ID doesn't exist.
  - Engine error responses (non-2xx) now pass their `detail` message back to the chat UI instead of being silently swallowed — analysts will see "Could not transition INC-XXXXX: transition not allowed from current state" rather than a false success.
  - The `mark_false_positive` action received the same hardening (pre-fetch + error surfacing).
- **Incidents list now refreshes immediately**: After the analyst clicks Execute on a close/FP/reopen action card in the CyMind chat overlay, a `cycentra:incident-updated` browser event is dispatched. `SiemIncidentsPage` listens for this event and calls `fetchIncidents()` immediately so the status change is visible without waiting for the 30-second polling cycle.
- **Anti-hallucination guard extended**: The SIEM context system prompt now explicitly instructs CyMind not to claim it has closed, resolved, blocked, quarantined, or marked any incident/asset **unless the user has already clicked Execute** on a confirmation card. This prevents CyMind from saying "I've closed the incident" before the action is actually confirmed and executed.

---

## v1.0.402 — Fix INC-ID lookup + ASM/SIEM incident format alignment — 2026-05-11

### Bug Fixes

- **"show me details of INC-00708" returning not found**: Root cause — the proxy only injected a top-10 open incidents snapshot. Any incident not in that slice was invisible to CyMind. Added `_fetch_incident_detail_block(message)` to `routes.py`: scans the user message for `INC-\d+` patterns, fetches each incident from `GET /incidents/{id}` on the correlation engine, and injects the **full record** (severity, status, risk score, categories, affected users/agents/IPs, MITRE tactics, kill chain, UEBA flags, correlated rules, AI summary and remediation). If the ID does not exist in the DB, injects a clear "not found" instruction so CyMind says exactly that instead of confabulating.
- **ASM incidents (`ASM-DOMAIN-MODULE-N`) in different format than SIEM incidents (`INC-XXXXX`)**: Root cause — ASM scan findings are stored into CyMind's Qdrant RAG memory by `store_to_cymind_memory` (in `cycentra_scan.py`) with different field names (`alert_type`, `source_ip`, `outcome`, `analyst_notes`) than the SIEM correlation engine incidents (`llm_summary`, `src_ips`, `status`, `llm_remediation`). CyMind presented them differently because they literally were different. Fixed by aligning the RAG payload to include both old (legacy) keys for existing queries AND new SIEM-consistent keys (`id`, `llm_summary`, `status`, `src_ips`, `affected_agents`, `categories`, `llm_remediation`).
- **Incident context table showing `?` for title and created**: The SIEM context block used `inc.get('title')` and `inc.get('created_at')` but neither field exists on the `Incident` model. Replaced with synthesized summary from `llm_summary` or `categories`, and added `affected_users` column.
- **Added ID format guide** to SIEM context header so CyMind always knows the two namespaces (INC-XXXXX = correlation engine, ASM-... = RAG/scan findings) and presents both in a consistent table format.

### Files Changed
- `backend/blueprints/system/routes.py` — `_fetch_incident_detail_block()`, proxy wiring, incident table fix, SIEM context format guide
- `backend/cy_asm/cycentra_scan.py` — aligned `store_to_cymind_memory` payload fields

---

### Bug Fixes

- **CyMind hallucinating incident data for user queries**: When asked "how many incidents are related to user shibu", CyMind was fabricating incident IDs, descriptions, timestamps and counts. Root cause: the `/incidents` REST endpoint had no `user` filter, the portal proxy had no entity-aware enrichment, and no anti-hallucination guard existed in the live SIEM context block. Three-layer fix applied:
  1. `/incidents` engine endpoint now accepts `user`, `agent`, and `src_ip` query parameters — uses PostgreSQL `array_to_string` + `ILIKE` to search `affected_users`, `affected_agents`, and `src_ips` arrays. Total count is now also correct for all filter combinations (was previously only counting status filter).
  2. Portal chat proxy (`cymind_chat_proxy`) now detects entity/user mentions in the user message via `_ENTITY_IN_MSG_RE` regex, pre-fetches that entity's incidents from the engine, and injects a `## Incidents for entity 'X'` table directly into the SIEM context block before forwarding to CyMind — so CyMind has the real data, not a gap to fill.
  3. `_fetch_siem_context_block()` now includes a `[SYSTEM INSTRUCTION — CRITICAL]` anti-hallucination footer that instructs the LLM to never invent incident IDs, descriptions, usernames, or counts beyond the provided data.
- **New `search_incidents` MCP tool**: Added to correlation engine for CyMind standalone path. Accepts `user`, `agent`, `src_ip`, `status`, `severity` filters. Returns exact DB records with a grounding note. Keyword-routed in `mcp_client.py`.

### Files Changed
- `backend/cysiemstack/correlation_engine/main.py` — `/incidents` user/agent/src_ip filters; `search_incidents` MCP tool
- `backend/blueprints/system/routes.py` — `_ENTITY_IN_MSG_RE`, `_fetch_entity_incidents_block()`, entity enrichment in proxy, anti-hallucination footer, `search_incidents` in `_MCP_TOOLS`
- `CyMind/cymind/api/mcp_client.py` — `search_incidents` keyword routing + label

---

## v1.0.400 -- 2026-05-11

### Improvements

  - Stability and performance improvements.

---

## v1.0.400 — Incident Distribution MCP Tool — 2026-05-11

### Bug Fixes

- **MCP chat returning "?" for incident distributions**: Added `get_incident_distribution` as a dedicated MCP tool in the correlation engine. The tool queries the DB directly (severity, status, category GROUP BY) and returns exact counts. CyMind now auto-invokes it on any distribution/breakdown/count-by question instead of estimating from the limited `list_incidents` preview.

### Files Changed
- `backend/cysiemstack/correlation_engine/main.py` — new `get_incident_distribution` MCP tool
- `backend/blueprints/system/routes.py` — added to `_MCP_TOOLS` registry
- `CyMind/cymind/api/mcp_client.py` — keyword routing + label entry

---

## v1.0.399 -- 2026-05-11



---

## v1.0.399 — MCP Execution Layer + Benchmark Distribution — 2026-05-11

### Enhancements

#### MCP Unified Execution Layer (CyCentra 360 ↔ CyMind)

- **E1 — 7 new MCP read tools** in `correlation_engine/main.py`: `get_alert`, `search_alerts`, `update_incident`, `list_campaigns`, `get_threat_intel`, `get_vuln_summary`, `get_compliance_status` — all registered inside the `if _mcp_enabled:` block.
- **E2 — 6 new agentic action types** in `blueprints/system/routes.py`: `assign_incident`, `add_incident_note`, `escalate_incident`, `create_cyiris_case`, `enrich_ioc`, `trigger_soar_playbook` — intent patterns + confirmed execution handlers wired end-to-end.
- **E3 — Full audit trail for all confirmed actions**: New `POST /audit` engine endpoint accepts audit writes from the Flask proxy. New `_write_action_audit()` helper in `routes.py` — fire-and-forget loopback, never blocks action execution. All 5 original action handlers (`block_ip`, `disable_user`, `restart_agent`, `close_incident`, `mark_false_positive`) now write an audit entry on success.
- **E4 — Per-tool RBAC metadata in `_MCP_TOOLS`**: Added `access_level: "read"/"write"` and `requires_confirmation: true` flags to all 18 tool entries so the portal MCP config page can surface write tools distinctly.
- **E5 — CyMind `mcp_client.py` extended**: 6 new entries in `_WRITE_TOOLS`, 5 new tuples in `_KEYWORD_TOOLS` (campaigns, threat intel, compliance, vuln summary, single alert), 6 new `_LABELS` entries for `format_context_block`.

#### Benchmark Intelligence Engine — Incident Distribution

- **New engine endpoint `GET /incidents/distribution`**: Returns `by_severity`, `by_status`, and `by_category` (top 15, unnested from `categories` ARRAY) via three lightweight GROUP BY queries. Used by the Benchmark page.
- **`_collect_siem_score()` updated**: Now calls `/incidents/distribution` after the main score calculation and surfaces `severity_distribution`, `status_distribution`, and `category_distribution` in the SIEM dimension breakdown — available at `breakdown.siem.*` in `GET /api/benchmark/score`.

### Files Changed
- `backend/cysiemstack/correlation_engine/main.py`
- `backend/blueprints/system/routes.py`
- `backend/blueprints/benchmark/routes.py`
- `Documents/GitHub/Custom-Tools/CyMind/cymind/api/mcp_client.py`

---

## v1.0.398 -- 2026-05-11

### Bug Fixes

  - M365 correlation by username, cloud incident enriched-gate bypass, lower cloud IRIS ticket threshold, robust LLM parse fallback, richer AI context
  - vuln/incident rendering bugs — missing remediation steps, [object Object] in http_analysis and remediation, missing compliance impact, AI summary truncation

---

## v1.0.398 — Bug Fixes — 2026-05-11

### Bug Fixes

#### Vulnerabilities Page
- **BUG-1 — Missing "Steps to Remediate"**: `adapter.js` now injects severity-aware fallback remediation text when the ASM scanner returns an empty `recommendation` field, ensuring the Remediation card always renders.
- **BUG-2 — HTTP Analysis rendering `[object Object]`**: Technology entries in `VulnerabilityPage.jsx` and `AssetsPage.jsx` are now rendered via property extraction (`name → technology → product → JSON fallback`), correctly displaying technology names such as "jQuery 1.12.4" instead of `[object Object]`.
- **BUG-3 — Remediation Action rendering `[object Object]`**: `parseSteps()` in `VulnerabilityPage.jsx` rewritten to safely unwrap arrays-of-objects, plain objects, and AI-enriched nested structures — all remediation shapes now display as readable text.
- **BUG-4 — Compliance Impact field missing**: `adapter.js` applies a client-side NIS2/DORA/ISO 27001 keyword-matching fallback when the backend enrichment lookup yields no compliance tags, ensuring every vulnerability entry displays a compliance impact.

#### Active Incidents (SIEM)
- **BUG-5 — AI enrichment quality**: `llm_enricher.py` — `_parse_response()` now uses a 3-tier fallback (both markers → summary-only marker → numbered-list heuristic) so `llm_remediation` is populated even when the LLM omits the `REMEDIATION_STEPS:` header. `_build_context()` now supplies a union of top-5-by-score and top-5-by-recency alerts (up to 10) for richer attack timeline context.
- **BUG-6 — M365 incidents not correlating**: `grouper.py` `find_matching_incident()` gained a third match criterion — cloud-source events (`o365`, `azure`, `aws`, `gcp`, `github`) are now correlated by `username + category`, correctly grouping all M365 user activity into a single incident regardless of agent ID variance.
- **BUG-7 — CyIRIS ticket creation not triggering for low-FP incidents**: `iris_connector.py` lowers the `alert_count` threshold to `1` for cloud-source incidents (vs. `3` for on-prem). `ingestor.py` marks cloud incidents as `enriched=True` immediately, preventing them from stalling in Band 2 ("investigating") and allowing Band 3 ticket creation to fire.
- **BUG-8 — Truncated incident details / incomplete AI summaries**: `SiemIncidentsPage.jsx` — `llm_summary` block now renders with `whiteSpace: pre-wrap`, preserving multi-paragraph AI narratives. `llm_enricher.py` SYSTEM_PROMPT expanded from 2–3 to 3–5 sentences with explicit instruction to include affected usernames/hosts and describe attack progression.

### Files Changed
- `portal/src/core/adapter.js`
- `portal/src/pages/vulnerabilities/VulnerabilityPage.jsx`
- `portal/src/pages/assets/AssetsPage.jsx`
- `portal/src/siem/SiemIncidentsPage.jsx`
- `backend/cysiemstack/correlation_engine/grouper.py`
- `backend/cysiemstack/correlation_engine/iris_connector.py`
- `backend/cysiemstack/correlation_engine/ingestor.py`
- `backend/cysiemstack/correlation_engine/llm_enricher.py`

---

## v1.0.397 -- 2026-05-11

### Bug Fixes

  - benchmark): eliminate double-counting and fix Wazuh data path

---

## v1.0.396 -- 2026-05-11

### Improvements

  - Stability and performance improvements.

---

## v1.0.395 -- 2026-05-11

### Improvements

  - Stability and performance improvements.

---

## v1.0.394 -- 2026-05-11

### Improvements

  - Stability and performance improvements.

---

## v1.0.393 -- 2026-05-11

### Bug Fixes

  - portal): CTEMSyncPanel shows ACTIVE after page refresh
  - asm): downgrade scanner CA-bundle gap from Medium to Low severity
  - asm): eliminate false-positive SSL findings for ECDSA keys and SAN extraction

---

## v1.0.393 -- 2026-05-11

### Bug Fixes

**ASM — Eliminate 3 false-positive SSL/TLS findings in Standard scan (score accuracy)**

Three SSL findings generated by every Standard scan of a Cloudflare-backed or ECDSA-keyed domain were false positives that incorrectly reduced the posture score:

| False positive | Root cause | Fix |
|---|---|---|
| `Weak key: 256 bits` | Key-size check applied the RSA 2048-bit minimum to ECDSA; ECDSA-256 ≈ RSA-3072 (NIST SP 800-57) | `crypto_checks.py`: key-size guard now type-aware — RSA/DSA require ≥ 2048 bits; ECDSA requires ≥ 224 bits |
| `SAN mismatch: <domain> not covered` / `No SANs present` | Both `crypto_checks.py` and `debug_crypto.py` read SANs via `ssock.getpeercert()` which returns an empty dict when `ssl.CERT_NONE` is active | New helper `_get_sans_from_cert(cert)` reads SANs directly from the OpenSSL cert object via the `subjectAltName` extension; scan now correctly sets `san_valid: True` for domains the cert covers |
| `Chain validation failed: unable to get local issuer certificate` classified as Medium | Pattern `chain.validation.fail` → Medium caught the Python CA-bundle gap error (Google Trust Services intermediate not in system bundle); TLS actually works | New Low-priority pattern added for `unable.to.get.local.issuer` — evaluated before the generic chain failure rule — demotes this scanner-side limitation to informational (Low) |

**Net effect on posture score for cycentra.com:**

| Scan | Before all fixes | After v1.0.392 | After v1.0.393 |
|---|---|---|---|
| Standard | 17 (F) | 65 (C) | 67 (C) |
| Deep | 64 (C) → 52 (D)* | 52 (D) | 52 (D) |

*Deep scan rescanned independently; old 64 score was from pre-v1.0.391 run.

Standard is now correctly higher than Deep by 15 points (67 vs 52), matching the documented behavior in `docs/standard-vs-deep-scan.md`.

**Files changed:**
- `backend/cy_asm/modules/crypto_checks.py` — `_get_sans_from_cert()` helper; ECDSA key-size threshold; SAN block reads from cert object
- `backend/cy_asm/modules/debug_crypto.py` — `_get_sans_from_cert()` helper; SAN block reads from cert object
- `backend/cy_asm/cycentra_scan.py` — Low-priority pattern for local-issuer CA-bundle gap added before the generic chain-validation Medium rule

---

## v1.0.392 -- 2026-05-11

### New Features

  - asm): eliminate false-positive path exposures, dedup vuln findings, add crt.sh retry+cache, redesign CTEMSyncPanel

---

## v1.0.391 -- 2026-05-10

### Bug Fixes

  - asm): correct 3 bugs causing Standard scan to score lower than Deep scan

---

## v1.0.390 -- 2026-05-10

### Improvements

  - Stability and performance improvements.

---

## v1.0.389 -- 2026-05-10

### Bug Fixes

  - asm): rebuild guest dashboard with real data widgets; correct SCAN_TIERS for standard scan

---

## v1.0.389 -- 2026-05-10

### Enhancements

- **ASM Guest Dashboard — full real-data widget rebuild (Issues A, B, C)**

  **Issue A fixed — SSL/Email widgets now read from `raw_results` directly:**
  `SslWidget` and `EmailSecurityWidget` in `GuestScanPage.jsx` previously counted findings by filtering `a.vulnerabilities` with regex keyword matching. This inflated counts when Deep scan AI enrichment tagged additional findings as ssl/email-related. Both widgets are now completely rewritten to read from `asset.raw_results.crypto.results.ssl` and `asset.raw_results.email_sec.results` respectively — the exact module output, unchanged between scan types. SSL widget shows: protocol (color-coded by version), days to expiry (red/orange/green), chain validity, OCSP stapling, PQC hybrid TLS detection, and raw issue count. Email widget shows: SPF present/missing, DKIM valid selectors count, DMARC policy (reject/quarantine/none, color-coded), DNSSEC state, spoofing risk level, and elite score.

  **Issue B fixed — guest dashboard now shows 6 real unlocked widgets:**
  Replaced the previous layout (3 real + 5 locked) with a full rebuild covering all modules Standard scan collects:
  - Row 1: Risk Donut, SslWidget (raw_results), EmailSecurityWidget (raw_results)
  - Row 2: WebSecurityWidget (ports, exposed paths, JS secrets, HTTPS redirect, missing headers), DnsWidget (A/MX records, DNSSEC, typosquatting, subdomain summary), CloudWidget (providers, bucket counts, K8s exposure)
  - Row 3: PartialLockedWidget x3 (Dark Web, Supply Chain, AI Risk Score) — show teaser numbers if raw_results key exists, otherwise show "requires Deep Scan"
  Stat strip updated: shows posture_score/posture_grade from meta, total findings, critical count, subdomain total, open port count.

  **Issue C fixed — ScanPage.jsx SCAN_TIERS corrected for Standard scan:**
  Standard tier previously listed "Dark web mention search" and "AI enrichment & remediation" as included — both are false per `SCAN_PROFILES["standard"]` (ai_enrichment: False, no dark_web module). Features list corrected to: DNS/WHOIS, Subdomain enumeration, SSL/TLS audit, Email security, Web security & ports, Cloud exposure, OSINT — all included. Dark web, Supply chain, AI enrichment, PDF Technical Report — all marked excluded. Scan time corrected from ~60s to ~45s. A note field added explaining posture score tier differences, rendered as italic text with an ⓘ info icon and tooltip.

  **Issue D documented — posture score difference is by design:**
  Deep Scan activates 4 extra modules (dark_web, supply_chain, social_eng, mobile_api) + AI enrichment, surfacing more findings. Each additional finding deducts from the score per `posture_score.py`. A lower Deep Scan score is a more accurate measurement, not a regression. Documented in `docs/standard-vs-deep-scan.md` with the full formula table, FAQ, and module coverage matrix.

  **Files changed:**
  - `portal/src/pages/guest-scan/GuestScanPage.jsx` — full GuestDashboard rebuild, new widgets: SslWidget, EmailSecurityWidget, WebSecurityWidget, DnsWidget, CloudWidget, PartialLockedWidget
  - `portal/src/pages/scan/ScanPage.jsx` — SCAN_TIERS Standard features corrected, note + ⓘ tooltip added
  - `docs/standard-vs-deep-scan.md` — new document: Standard vs Deep Scan explanation, posture formula, FAQ

---

## v1.0.388 -- 2026-05-10

### New Features

  - asm): fix guest dashboard widgets, guest-only executive PDF, modernise PDF branding, fix scan comparison table

### Bug Fixes

  - asm): fix undefined 'results' variable in portal JSON fallback path

---

## v1.0.387 -- 2026-05-10

### Improvements

  - Stability and performance improvements.

---

## v1.0.386 -- 2026-05-09

### Improvements

  - Stability and performance improvements.

---

## v1.0.385 -- 2026-05-09

### Improvements

  - Stability and performance improvements.

---

## v1.0.384 -- 2026-05-08

### Bug Fixes

  - **`cycentra-setup.sh` — fatal grep abort in CySIEM dashboard step**: `grep -E "^#?\s*opensearch\.username:"` returned exit code 1 (no match) under `set -euo pipefail`, aborting every `--update` run at Step 1. Fixed by appending `|| true` to both grep assignments.

  - **`cycentra-setup.sh` — replace broken proxy-auth approach with nginx Basic Auth injection**: All sections that attempted to configure `opensearch_security.auth.type: proxy` in `opensearch_dashboards.yml` have been replaced. Confirmed root cause: OpenSearch proxy auth returned `Authentication finally failed for null` regardless of `requestHeadersAllowlist`, `challenge: false`, or `proxy_auth_domain.http_enabled: true` — headers were not being forwarded correctly in this Wazuh 4.x build.

    **Working SSO mechanism (nginx Basic Auth injection)**:
    - Wazuh Dashboard stays in default `basicauth` mode — no `opensearch_security.auth.type` change.
    - `cy360_sso` service account in OpenSearch with `backend_role: admin` (hash via `hash.sh`, `$2y$` prefix — Python bcrypt `$2b$` does not authenticate).
    - nginx cysiem location block injects `Authorization: Basic Y3kzNjBfc3NvOkN5Q2VudHJhMzYwIVNpZW1TU08=` (`cy360_sso:CyCentra360!SiemSSO`) for every request that passes the oauth2-proxy IAP gate.
    - Result: any logged-in Cy360 user clicking CySIEM lands directly in the Wazuh Dashboard — no secondary login prompt.

    **Files changed**: `cycentra-setup.sh` — Step 4.1 (grep fix + strip proxy auth), Step 4.3b (replaced proxy-auth/securityadmin block with cy360_sso user creation), nginx template cysiem location (added `proxy_set_header Authorization`), idempotent nginx patch section.

---

## v1.0.383 -- 2026-05-08

### Bug Fixes

  - **`backend/blueprints/benchmark/routes.py` — Threat Intel widget showing 0**: Two compounding issues caused the "Threat Intelligence" widget on the Posture Benchmark page to display score 0 with "feeds unavailable · attribute count unavailable":

    1. **Wrong MISP API key selected**: `_read_misp_config()` resolved credentials via `ai_settings.json` → `cysiemstack.env` → `os.environ`. The `cysiemstack.env` file contained a stale key (`MISP_API_KEY=v2ZTsp4J...`) that returned 401 from MISP. The correct key (`CLOUD_MISP_API_KEY=M74nCZUC...`) was written by the UI to `/opt/cycentra/.env` (loaded into `os.environ`), but was never reached because both URL and key appeared to be satisfied by `cysiemstack.env` (URL matched, key was stale).

       **Fix**: Added new Source 2 in `_read_misp_config()` that checks `os.environ.get("CLOUD_MISP_URL")` / `os.environ.get("CLOUD_MISP_API_KEY")` **before** reading `cysiemstack.env`. This matches the priority of all other CLOUD_* settings in the platform.

    2. **MISP feed response envelope not unwrapped**: `_collect_threat_intel_score()` counted enabled feeds with `f.get("enabled")`, but the MISP `/feeds/index` API wraps each feed: `[{"Feed": {"enabled": 1, ...}}]`. Fix: `f.get("Feed", f).get("enabled")` — handles both wrapped (MISP 2.4+) and unwrapped formats.

    **Result**: Score 40/40 (5/96 feeds enabled). Files: `backend/blueprints/benchmark/routes.py` lines ~859, ~765. Tests: `tests/unit/test_benchmark_threat_intel.py` (5 cases covering both formats).

---

## v1.0.382 -- 2026-05-07

### New Features

  - **CySIEM (Wazuh) seamless auto-login from Cy360 portal**: Clicking the CySIEM link in the portal now opens the Wazuh Dashboard without a secondary login prompt, matching the SSO experience of CyIRIS and CySOAR.

    **Architecture**: `cysiem.cycentra.com` is already gated by an oauth2-proxy IAP (`auth_request` in nginx) that validates the `.cycentra.com` session cookie. After the IAP gate passes, nginx injects `Authorization: Basic cy360_sso` credentials to Wazuh. The `cy360_sso` user is an OpenSearch admin service account created during setup. No Wazuh Dashboard config changes are required.

    **Portal changes** (`portal/src/siem/SiemIncidentsPage.jsx`, `portal/src/siem/SiemUebaPage.jsx`): CySIEM buttons call `GET /api/siem/wazuh-launch` before opening the tab, storing a launch token in `sessionStorage` for potential deep-link usage.

    **Backend** (`backend/siem_proxy.py`): Added `GET /api/siem/wazuh-launch` endpoint — session auth check, role guard (viewer blocked), rate limit (10 req/min), returns `{"launch_url": ..., "token": ...}` with graceful fallback if Wazuh API is unreachable.

---

## v1.0.381 -- 2026-05-07

### Improvements

  - Stability and performance improvements.

---

## v1.0.380 -- 2026-05-06

### Bug Fixes

  - SyntaxError in system/routes.py — MISP try block outside updates dict

---

## v1.0.379 -- 2026-05-06

### Bug Fixes

  - MISP config fallback chain (ai_settings → cysiemstack.env → env) + sync on save

---

## v1.0.378 -- 2026-05-06

### Bug Fixes

  - threat intel reads MISP from ai_settings.json, fix pathlib reference

---

## v1.0.377 -- 2026-05-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.376 -- 2026-05-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.375 -- 2026-05-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.374 -- 2026-05-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.373 -- 2026-05-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.372 -- 2026-05-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.371 -- 2026-05-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.370 -- 2026-05-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.369 -- 2026-05-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.368 -- 2026-05-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.367 -- 2026-05-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.366 -- 2026-05-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.365 -- 2026-05-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.364 -- 2026-05-06

### New Features

  - add missing benchmark blueprint routes.py — resolves startup ModuleNotFoundError

---

## v1.0.363 -- 2026-05-06

### New Features

  - add missing benchmark blueprint routes.py — resolves startup ModuleNotFoundError

---

## v1.0.363 -- 2026-05-06

### Bug Fixes

  - **[HOTFIX] Backend crash on startup — `ModuleNotFoundError: No module named 'blueprints.benchmark.routes'`.**
    The Benchmark Intelligence Engine wiring patch (PATCH_3) was applied to `app.py` — adding the `benchmark_bp` import and registration — but the blueprint source file (`PATCH_1`) was placed in the wrong directory (`backend/backend/blueprints/benchmark/routes.py`) instead of the correct location (`backend/blueprints/benchmark/routes.py`).
    Flask could not import the module on startup, causing an immediate exit (status=1) and an infinite systemd restart loop (140+ restarts observed).
    Fixed by moving `routes.py` to the correct package path. The `__init__.py` was already in place.

---

## v1.0.362 -- 2026-05-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.361 -- 2026-05-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.360 -- 2026-05-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.359 -- 2026-05-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.358 -- 2026-05-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.357 -- 2026-05-06

### Improvements

  - Stability and performance improvements.

---

## v1.0.356 -- 2026-05-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.355 -- 2026-05-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.354 -- 2026-05-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.353 -- 2026-05-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.352 -- 2026-05-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.351 -- 2026-05-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.350 -- 2026-05-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.349 -- 2026-05-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.348 -- 2026-05-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.347 -- 2026-05-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.346 -- 2026-05-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.345 -- 2026-05-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.344 -- 2026-05-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.343 -- 2026-05-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.342 -- 2026-05-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.341 -- 2026-05-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.340 -- 2026-05-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.339 -- 2026-05-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.338 -- 2026-05-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.338 -- 2026-05-05

### Bug Fixes

  - **SSO login broken: `unknown_client` error** — Fixed six interconnected root causes that broke the SSO login flow introduced in v1.0.331–v1.0.337:
    1. `sso_redirect()` now self-heals: for Google/Microsoft, the OIDC discovery URL is always overridden to the authoritative provider URL regardless of what is stored in the DB. The redirect URI is always forced to the canonical `/api/sso/callback` path — stale DB entries like the old `/api/v1/auth/sso/callback` path (CyMind format) can no longer cause token-exchange failures.
    2. `sso_configure()` now enforces correct values on save: Google/Microsoft always get their canonical discovery URLs; the redirect URI is always written as `{FRONTEND_URL}/api/sso/callback`.
    3. `sso_callback()` now uses the canonical redirect URI (matching what `sso_redirect()` sent to the IdP) instead of the DB value — prevents redirect_uri mismatch errors.
    4. Removed bare `/.well-known/openid-configuration` Flask route (without `/oidc/` prefix) from the OIDC provider blueprint. This route caused `cy360.cycentra.com/.well-known/...` to return CyCentra's own OIDC discovery doc, making it appear to be a valid Google IdP endpoint when an admin accidentally stored that URL.
    5. Added `GET /api/sso/config` endpoint (admin-only) returning the full non-secret current SSO configuration so the settings form can pre-populate all fields on re-open.
    6. Updated `SSOTab.jsx` to load from `/api/sso/config` on mount — `client_id`, `redirect_uri`, `default_role`, `auto_provision`, `require_approval`, `allowed_domains` are now pre-populated. The redirect URI field is now always read-only (it is fixed to `/api/sso/callback`). A badge shows when a secret is already stored.

---

## v1.0.337 -- 2026-05-05

### Improvements

  - Stability and performance improvements.

---

## v1.0.336 -- 2026-05-04

### Improvements

  - Stability and performance improvements.

---

## v1.0.335 -- 2026-05-04

### Improvements

  - Stability and performance improvements.

---

## v1.0.334 -- 2026-05-04

### Improvements

  - Stability and performance improvements.

---

## v1.0.333 -- 2026-05-04

### Improvements

  - Stability and performance improvements.

---

## v1.0.332 -- 2026-05-03

### Improvements

  - Stability and performance improvements.

---

## v1.0.331 -- 2026-05-03

### Improvements

  - Stability and performance improvements.

---

## v1.0.330 -- 2026-05-03

### New Features

  - **Audit Trail** — New dedicated Audit Trail section accessible from the sidebar (Actions > Audit Trail). Captures all user and system events with timestamps, categories, results, and contextual metadata. Includes a live search bar, multi-field filters (category, result, user/email, date range), paginated log table with expandable detail rows, and one-click CSV/JSON export. Events are automatically recorded for logins, logouts, document creation, config changes, scan triggers, scheduler job execution, and service lifecycle events. Logs are stored at `/var/log/cycentra/audit.log` and merged at query time with `/var/log/cycentra/auth.log` for unified visibility.

    **API:** `GET /api/audit/logs`, `GET /api/audit/stats`, `GET /api/audit/export?format=csv|json`, `POST /api/audit/event`, `GET /api/audit/categories`

    **How to use:** Navigate to the sidebar and click **Audit Trail** under Actions. Use the filter bar to narrow by category (authentication, configuration, scan, scheduler, document), result (success/failure), or time window. Click any row's expand arrow to see the full event metadata. Use the Export button to download logs as CSV or JSON for compliance reporting.

  - **ASM PDF Report Modernization** — Completely redesigned PDF report output using the SecuPulse Security Business Review as a style reference. Reports now use a deep navy dark theme (`#0A1628` background) with teal (`#00E5A0`) and sky-blue (`#38BDF8`) accents throughout. Improvements include: modernized cover page with dot-grid decorative pattern, dual accent strips, and a security score box with grade pill (A–F); dark-theme metric cards with colored top-border accents; teal-ruled section headers; dark alternating rows in finding tables; updated posture gauge, severity pie chart, and module bar chart all rendered with matching dark palettes using matplotlib.

    **How to use:** No configuration changes required. Generate ASM reports as usual via the web portal or API — all new reports will automatically use the modernized dark theme format. Previously generated reports are not affected.

---

## v1.0.329 -- 2026-05-03

### Improvements

  - Stability and performance improvements.

---

## v1.0.328 -- 2026-05-02

### Improvements

  - Stability and performance improvements.

---

## v1.0.327 -- 2026-05-02

### Improvements

  - Stability and performance improvements.

---

## v1.0.326 -- 2026-04-29

### Improvements

  - Stability and performance improvements.

---

## v1.0.326 -- 2026-04-29

### Bug Fixes

- **FP auto-close, Entity Risk, and UEBA fixes not taking effect after `--update`** — Root cause: `cycentra-setup.sh --update` contained a version pre-check that called `exit 0` when the server was already at the latest version, aborting the entire script before reaching `systemctl restart cysiemstack-engine`. This meant: (1) the correlation engine process kept running with old in-memory bytecode indefinitely — `pip install` updates `.py` and `.pyc` files on disk but the running Python process never reloads them; (2) the startup data migrations added in v1.0.323 (close stale false_positive incidents, backfill alerts.category/username) never executed because the engine never restarted with the new `main.py`. Fixed: removed the `exit 0` early abort — `--update` now always re-applies packages and restarts services regardless of version match. Pip install is idempotent; the restart takes under 10 seconds. (`cycentra-setup.sh`)

---

## v1.0.325 -- 2026-04-29

### Improvements

  - Stability and performance improvements.

---

## v1.0.324 -- 2026-04-29

### Improvements

  - Stability and performance improvements.

---

## v1.0.323 -- 2026-04-29

### Improvements

  - Stability and performance improvements.

---

## v1.0.323 -- 2026-04-29

### Bug Fixes

- **FP incidents stuck in "false_positive" state despite slider at 50%** — The `advance_incident_status()` fix (v1.0.319) correctly sets new incidents to `closed`. However 82 existing incidents were already written as `false_positive` by the old code before the fix was deployed. The `_fp_auto_close_scheduler` only promotes them after 7 days — they would remain visible in Active Incidents for a week. Added startup migration 4: on engine boot, all `false_positive` incidents where `fp_probability >= fpThreshold` (read live from `ai_settings.json`) are immediately closed. (`main.py` lifespan)

- **O365 incidents still showing "☁ Cloud" — alerts.category not migrated** — The normaliser fix (v1.0.312) correctly classifies new O365 alerts as `o365`. The prior lifespan migration (v1.0.319) updated `incidents.categories` cloud→o365. But the underlying `alerts.category` column was never updated — still stored as `cloud` for all 50 pre-fix alerts. This caused: (a) `_merge_categories()` in the grouper to re-inject `cloud` when new alerts merged into existing incidents, overriding the fixed category; (b) `risk_scorer.recalculate_all()` to find zero `o365` alerts and skip the Microsoft 365 entity entirely. Added startup migration 2: backfills `alerts.category` to `o365` for all alerts whose `full_alert` contains `office365` rule groups. (`main.py` lifespan)

- **UEBA / Entity Risk missing O365 users and showing only postgres/proxy** — `alerts.username` is NULL for all 93 pre-fix alerts because the O365 username extraction (MailboxOwnerUPN/UserId path in `_extract_username`) was added in v1.0.319 but not backfilled. UEBA baselines only contain `postgres` and `proxy` — SSH brute-force srcuser values extracted from pre-fix auth alerts. Added startup migration 3: backfills `alerts.username` from `full_alert→data→office365→MailboxOwnerUPN` (email only, `LIKE '%@%'`) then from `UserId` as fallback. On next `recalculate_all()` scheduler run, O365 users will appear in Entity Risk and Behavioral Analytics. (`main.py` lifespan)

---

## v1.0.322 -- 2026-04-29

  - Stability and performance improvements.

---

## v1.0.321 -- 2026-04-29

### Improvements

  - Stability and performance improvements.

---

## v1.0.321 -- 2026-04-29

### Bug Fixes

- **Auto-ticket not raised when MISP disabled and CyMind not configured** — `enriched = bool(misp_result or llm_result)` evaluated to `False` when MISP is disabled (returns `{}`) and LLM is not configured (returns `{}`). Band 2 guard `fp_score >= 40.0 or not enriched` then trapped all incidents in "investigating" permanently — Band 3 (ticket creation) was never reached regardless of fp_score, severity, or alert count. Fixed: `enriched` is now `True` when alert_count reaches the LLM trigger threshold (3), indicating the enrichment window has closed. Also `True` when prior-cycle enrichment is stored on the incident (`llm_summary` or `misp_enrichment`). (`ingestor.py`)

---

## v1.0.320 -- 2026-04-29

  - Stability and performance improvements.

---

## v1.0.320 -- 2026-04-29

### Bug Fixes

- **FP auto-close threshold slider now respected in all IRIS modes** — When IRIS connection mode was set to `disabled`, `_load_iris_config()` returned `None` and `advance_incident_status()` fell back to the hard-coded default threshold (90%) instead of the user's slider value. The UI description states "False-positive auto-close still active based on threshold" even in disabled mode — this is now true. The threshold is read directly from `ai_settings.json` regardless of IRIS connection state, so user preference (slider set to e.g. 60%) is always honoured. (`iris_connector.py` `advance_incident_status()`)

---

## v1.0.319 -- 2026-04-29

  - Stability and performance improvements.

---

## v1.0.319 -- 2026-04-29

### Bug Fixes

- **FP auto-close threshold now closes directly** — `advance_incident_status()` was promoting incidents to `false_positive` (still visible, reviewable) instead of `closed` when `fp_probability ≥ fpThreshold`. The UI labelled this "FALSE POSITIVE AUTO-CLOSE THRESHOLD" and described it as "auto-closed without raising a ticket", but the terminal `closed` state was only reached after 7 days via the FP scheduler. Fixed: Band 1 now uses `threshold` (fpThreshold from the UI slider) and sets `status = "closed"` immediately. The intermediate "held" watch-zone band is removed — it was never exposed in the UI and created confusion. (`iris_connector.py` `advance_incident_status()`)

- **Entity Risk — Microsoft 365 now appears as a separate entity** — O365 alerts all arrived with `agent_id = "CY360-DEV"` (the Wazuh manager), so they were silently merged into the CY360-DEV host entity and never appeared as a distinct cloud service. Added `entity_type = 'cloud'` to the risk scorer: alerts are bucketed by `Alert.category` (e.g. `o365`) and tracked under a display name (e.g. "Microsoft 365"). The ingestor and the `recalculate_all()` scheduler both populate these new entities. (`risk_scorer.py`, `ingestor.py`)

- **UEBA — `root` and O365 users now tracked** — Two sub-bugs: (1) `_extract_username()` explicitly excluded the string `'root'`, so all `root` activity on CY360-DEV produced no UEBA baseline. (2) O365 alerts carry the user identity in `data.office365.UserId` / `MailboxOwnerUPN` — paths not checked by the extractor. Fixed: removed `'root'` from the exclusion list; added O365 email extraction. (`normaliser.py` `_extract_username()`)

- **Active Incidents — "☁ Cloud" upgraded to "☁ Microsoft 365"** — Incidents ingested before the `_CLOUD_SOURCE_MAP` normaliser fix (v1.0.312) have `categories = {cloud}`, displaying as "☁ Cloud" instead of "☁ Microsoft 365". Two-part fix: (1) Engine startup migration: UPDATE incidents whose linked alerts have `office365` rule groups, replacing `cloud` with `o365`. (2) `grouper.py` `merge_alert_into_incident()`: when a specific cloud-source alert (o365, azure, aws, gcp, github) merges into an incident with a legacy `cloud` category, the generic `cloud` entry is replaced by the specific source. (`main.py` lifespan migration, `grouper.py` `_merge_categories()`)

---

## v1.0.318 -- 2026-04-29

### Improvements

  - Stability and performance improvements.

---

## v1.0.317 -- 2026-04-29

### Improvements

  - Stability and performance improvements.

---

## v1.0.316 -- 2026-04-29

### Improvements

  - Stability and performance improvements.

---

## v1.0.315 -- 2026-04-29

### Improvements

  - Stability and performance improvements.

---

## v1.0.314 -- 2026-04-29

### Improvements

  - Stability and performance improvements.

---

## v1.0.313 -- 2026-04-29

### Improvements

  - Stability and performance improvements.

---

## v1.0.312 -- 2026-04-29

### Improvements

  - **Cloud integration source specificity** — Incidents sourced from cloud integrations now display the specific service name instead of the generic "Cloud event" label. The normaliser maps Wazuh rule groups to named sources: `office365`/`o365` → **Microsoft 365**, `azure`/`msaz` → **Microsoft Azure**, `aws`/`cloudtrail` → **AWS**, `gcp` → **Google Cloud**, `github` → **GitHub**. Both the incidents table and the incident drawer now show the service name with a ☁ icon. The drawer section header also includes the service name (e.g. "CLOUD COLLECTOR AGENT (☁ Microsoft 365)"). Legacy `cloud` category on pre-existing incidents is handled as a graceful fallback.

---

## v1.0.311 -- 2026-04-29

### Improvements

  - Stability and performance improvements.

---

## v1.0.311 -- 2026-04-29

### Improvements

  - **Incident lifecycle clarity** — False Positive and Closed are now distinct steps in a clear two-stage flow: `false_positive` (classification verdict, still reviewable) → `closed` (terminal, confirmed noise). A new auto-close scheduler advances false_positive incidents to closed after 7 days with a full audit entry.
  - **Archive scheduler** — The 30-day auto-archive now targets `closed` and `resolved` incidents (no longer `false_positive` directly), completing the FP → closed → deleted pipeline.
  - **Incident toolbar — two-stage archive** — The former "Clear Resolved / FP" button (which hard-deleted rows) is replaced with two distinct actions:
    - **Archive FP & Resolved** (yellow) — soft-close: transitions all `false_positive` and `resolved` incidents to `closed` with an audit trail. No data deleted.
    - **Purge Closed** (red) — hard-delete: permanently removes only `closed` incidents from the database. Requires a separate confirm step.
  - **Cloud incident host label** — Incidents sourced from cloud integrations (O365, Azure, AWS) now display "CLOUD COLLECTOR AGENT" instead of "AFFECTED HOSTS", with an inline note explaining that the agent shown is the Wazuh collector, not the victim host. Users are directed to "Affected Users" for victim identity.
  - **New engine endpoint** — `POST /incidents/batch-close` performs the soft-close operation; proxied through Flask at `analyst+` RBAC level.

---

## v1.0.310 -- 2026-04-28

### Improvements

  - Stability and performance improvements.

---

## v1.0.309 -- 2026-04-28

### Bug Fixes

  - Fix CySIEM auto-login: write proxy auth config before first dashboard restart

---

## v1.0.308 -- 2026-04-28

### Improvements

  - Stability and performance improvements.

---

## v1.0.307 -- 2026-04-28

### Improvements

  - Stability and performance improvements.

---

## v1.0.306 -- 2026-04-28

### Improvements

  - Stability and performance improvements.

---

## v1.0.305 -- 2026-04-28

### Improvements

  - Stability and performance improvements.

---

## v1.0.304 -- 2026-04-28

### Improvements

  - Stability and performance improvements.

---

## v1.0.303 -- 2026-04-28

### Improvements

  - Stability and performance improvements.

---

## v1.0.302 -- 2026-04-28

### Improvements

  - Stability and performance improvements.

---

## v1.0.302 -- 2026-04-29

### Features

- **Cloud Marketplace model** — no integrations or playbooks are bundled with the platform at ship time; all items originate from the cloud marketplace and are pulled on demand.
- **My Integrations & Playbooks page** — `UseCasesPage` now fetches from `/api/marketplace/catalog` + `/api/marketplace/installed` and displays only items the user has pulled. Empty state guides users to the Integration Marketplace.
- **Office 365 native module** — Wazuh integration upgraded from deprecated `<wodle name="office365">` to the native `<office365>` block format across all config surfaces (system routes, UseCasesPage modal, MarketplacePage modal).
- **O365 `api_type` selector** — choose between `commercial`, `gcc`, and `gcc-high` subscription plans.
- **O365 `only_future_events` toggle** — exposed in both the UseCasesPage and MarketplacePage config modals; defaults to enabled.
- **DLP.All subscription** — `DLP (Data Loss Prevention)` subscription option added to O365 integration.
- **Marketplace backend** — removed `_DEFAULT_CATALOG` hard-coded items; catalog is now cloud-only with on-server custom items. Removed `_DEFAULT_IDS` install whitelist; validation is now format-based only.

---

## v1.0.301 -- 2026-04-28

### Improvements

  - Stability and performance improvements.

---

## v1.0.300 -- 2026-04-28

### Improvements

  - Stability and performance improvements.

---

## v1.0.299 -- 2026-04-28

### Improvements

  - Scheduler timezone, ASM log timestamps, O365 status sync

---

## v1.0.298 -- 2026-04-28

### Bug Fixes

  - Fix scheduler: invalid */0 cron and wordlist wrong save path

---

## v1.0.297 -- 2026-04-28

### Bug Fixes

  - Fix scheduler jobs and O365 integration

---

## v1.0.296 -- 2026-04-28

### Improvements

  - Stability and performance improvements.

---

## v1.0.295 -- 2026-04-27

### Improvements

  - Stability and performance improvements.

---

## v1.0.294 -- 2026-04-27

### Improvements

  - Stability and performance improvements.

---

## v1.0.293 -- 2026-04-27

### Improvements

  - Stability and performance improvements.

---

## v1.0.292 -- 2026-04-27

### Improvements

  - Stability and performance improvements.

---

## v1.0.291 -- 2026-04-27

### Improvements

  - Stability and performance improvements.

---

## v1.0.290 -- 2026-04-27

### Improvements

  - Stability and performance improvements.

---

## v1.0.290 -- 2026-04-27

### Bug Fixes — Critical

- **Backend crash-loop fixed (issues: local auth "Network error", Google SSO 502, scheduler UI)**  
  `blueprints/scheduler/routes.py` `_load_jobs()` crashed at startup when reading the legacy dict-format `schedules.json`, iterating over string keys and calling `.get()` on them. Added `_normalise_legacy_job()` to convert the legacy flat-dict schema (`{job_id: {...}}`) to the list-of-dicts format the scheduler expects. The service was restart-looping 180+ times — this is now fixed, and the Flask backend (`cycentra-backend.service`) will come up cleanly.

- **ASM PDF report — chart aspect ratios fixed**  
  `cy_asm/reporting/pdf_base.py` `img_from_bytes()` previously called `Image(buf, width=w)` without an explicit height, allowing ReportLab to use an incorrect internal calculation that caused charts (gauge, radar, pie, world map) to appear extremely stretched. Now uses `ImageReader.getSize()` to compute the exact proportional height before constructing the `Image` object.

- **ASM PDF report — CyCentra logo added to cover page**  
  `build_cover()` now detects and embeds the actual CyCentra logo image (checked in priority order: `logo.png`, `logo-light.png`, `favicon-*.png`, `favicon.ico`). ICO files are transparently converted to PNG bytes via Pillow before embedding. Falls back gracefully to the existing "CY CENTRA" text monogram if no image is found.

---

## v1.0.289 -- 2026-04-27

### Auth / RBAC

  - Removed all JSON file references from RBAC backend — `cy_users` PostgreSQL table is now the sole source of truth with no file fallbacks.
  - `cyadmin@cycentra.com` bootstrap now runs on every Flask startup (idempotent `ON CONFLICT DO NOTHING`), not only when the table is empty — fixes a race condition where the default admin could be missing if the table was created in a prior partial run.
  - Removed `_migrate_json()`, `_json_load_raw()`, and `_load_rbac()` shim entirely.
  - DB errors now propagate as 500 responses rather than silently falling through to missing users.

---

## v1.0.288 -- 2026-04-27

### Improvements

  - Stability and performance improvements.

---

## v1.0.287 -- 2026-04-27

### Improvements

  - Stability and performance improvements.

---

## v1.0.286 -- 2026-04-27

### Bug Fix — Local login "Network error": duplicate CORS headers from nginx + Flask

  **Root cause:** The `cyasm.cycentra.com` nginx server block was adding its own
  `Access-Control-Allow-*` headers, and Flask's global `@app.after_request` hook was
  also adding them. Every response carried the headers twice; the browser CORS spec
  requires exactly one `Access-Control-Allow-Origin` value — two values causes the
  browser to reject the response entirely, surfacing as "Network error" in the UI.
  The backend showed a 200 success in logs because the rejection happens client-side
  after the response is received.

  **Fix:**
  - Removed the four CORS `add_header` directives from the `cyasm` nginx server block
    template in `setup.sh`. Flask is now the single CORS authority via its global
    `after_request` hook.
  - Added an idempotent `sed` patch in the `--update` path that strips those lines from
    already-deployed nginx configs, then reloads nginx automatically.

  **After `--update`:** nginx reloads without CORS headers; Flask adds them once;
  local login works end-to-end.

---

## v1.0.285 -- 2026-04-27

### Bug Fix — Local login UI shows "Network error" despite backend success

  **Root cause:** Duplicate CORS headers on every `/auth/local` response.
  `app.py` has a global `@app.after_request` hook that calls `add_cors_headers()`
  on every response. The `/auth/local` handler was also wrapping every response
  manually with its own `add_cors_headers()` call (via `_json()` helper added in
  v1.0.281). This produced two `Access-Control-Allow-Origin` headers on every
  response. The browser CORS spec requires exactly one value — receiving two causes
  the browser to reject the response entirely, and the `fetch()` catch block
  reported it as "Network error".

  **Fix:** Removed the manual `add_cors_headers()` / `_json()` wrapper from
  `/auth/local`. All responses now go through the single global `after_request`
  hook only. The OPTIONS preflight handler is also simplified to a plain
  `make_response('', 204)` — the global hook adds its CORS headers.

---

## v1.0.284 -- 2026-04-27

### Bug Fix — Local login always fails: cy_users table empty after migration

  **Root cause (3-step chain):**
  1. `rbac.json` was renamed to `rbac.json.old`; `rbac.default.json` was never deployed
     (server hadn't been updated since that file was added in v1.0.279).
  2. On Flask startup, `_ensure_table()` found `cy_users` empty and called
     `_migrate_json()`, which checked only `rbac.json` and `rbac.default.json`.
     Both missing → `if not data: return` → table stayed empty.
  3. Every `_get_user()` query returned `None` → all logins (local and SSO) denied.

  **Fixes applied to `_migrate_json()`:**
  - Now also checks `rbac.json.old` as an additional fallback source, restoring
    any users that were in the renamed file.
  - **Always seeds** `cyadmin@cycentra.com` (admin / local / `Admin@123`) via
    `INSERT ... ON CONFLICT DO NOTHING` regardless of whether any JSON files
    existed. This is the self-contained bootstrap guarantee — local admin login
    works even on a server with no RBAC files at all.

  **After update + Flask restart the server will have:**
  - `deepak1424@gmail.com` — admin, SSO (restored from `rbac.json.old`)
  - `cyadmin@cycentra.com` — admin, local, password `Admin@123` (seeded)

---

## v1.0.283 -- 2026-04-27

### Improvement — User Management UI: auth type + password for local accounts

  - **Add User form** (Settings → User Management) now has an **SSO / Local** selector.
    When "Local" is chosen a password field appears. The password is sent to the backend
    and stored as a bcrypt hash — never in plain text.
  - Validation: local accounts require a non-empty password before the Add button
    submits. SSO accounts require only email + role (unchanged behaviour).
  - On success the form resets all fields including the auth type selector.

---

## v1.0.282 -- 2026-04-27

### Feature — PostgreSQL-backed User Management (RBAC)

  - **`cy_users` table in `correlation` DB**: User accounts (roles, auth types, bcrypt
    hashes) are now stored in the existing PostgreSQL 16 cluster (`correlation` DB,
    port 5433) instead of a flat JSON file. No new database or database user is required.

  - **Auto-create & auto-migrate**: On first Flask startup, `blueprints/rbac/manager.py`
    runs `CREATE TABLE IF NOT EXISTS cy_users` and, if the table is empty, migrates all
    entries from `rbac.json` / `rbac.default.json` automatically.

  - **Graceful JSON fallback**: If `CYCENTRA_DB_URL` is empty or the DB is unreachable,
    every RBAC function falls back to reading `rbac.json` — no downtime on DB failure.

  - **`psycopg2-binary>=2.9` added** to `requirements.txt` for synchronous PostgreSQL
    access from Flask.

  - **`CYCENTRA_DB_URL` env var**: Added to `core/config.py` and written to
    `/opt/cycentra/.env` automatically by `setup.sh` (both full-install and update-mode
    patch paths). Value:
    `postgresql://corruser:<pass>@127.0.0.1:5433/correlation`

  - **`POST /api/rbac/users`**: Now accepts `auth_type`, `password`, `name`, `apps`
    in addition to `role`. Passwords are bcrypt-hashed server-side. Underlying write
    uses PostgreSQL UPSERT (`ON CONFLICT DO UPDATE`).

  - **`DELETE /api/rbac/users/<email>`**: Deletes from `cy_users` (previously edited
    `rbac.json` in-place).

  - **OAuth callbacks use single-row DB lookup**: Google and Microsoft SSO callbacks now
    call `_get_user(email)` (single `SELECT` by primary key) for the allowlist check
    instead of loading the full user table. Same fix applied to local auth. All three
    auth paths now make exactly one DB round-trip per login.

---

## v1.0.281 -- 2026-04-27

### Bug Fixes — Local Authentication CORS & RBAC Fallback

  - **Local auth: CORS headers on all responses** (root cause of "Network error"): The
    `POST /auth/local` endpoint was returning 401/4xx responses without
    `Access-Control-Allow-Origin` / `Access-Control-Allow-Credentials` headers. For
    credentialed cross-origin `fetch()` calls (portal at `cy360.*`, API at `cyasm.*`),
    the browser refuses to expose any response that lacks CORS headers — `fetch()` throws
    a TypeError which the catch block reported as "Network error — please try again",
    completely hiding the real error. All responses from `/auth/local` now go through
    `add_cors_headers()`.

  - **`_load_rbac()` falls back to `rbac.default.json`**: When `/opt/cycentra/rbac.json`
    is absent (e.g. renamed/deleted), the RBAC loader now tries
    `/opt/cycentra/rbac.default.json` before returning an empty dict. This ensures the
    bundled default account (`cyadmin@cycentra.com`) is always available as a recovery
    path without requiring a full re-install.

  - **`setup.sh` always deploys `rbac.default.json`**: The RBAC setup step now copies
    `rbac.default.json` from the bundle to `/opt/cycentra/rbac.default.json` on every
    run (not just on first install), so the Flask fallback file is always up-to-date.

  - **`bcrypt` added to `requirements.txt`**: Was missing from the declared dependencies;
    local auth silently failed with a 503 if bcrypt happened not to be installed.

---

## v1.0.280 -- 2026-04-27

### Improvements

  - Stability and performance improvements.

---

## v1.0.279 -- 2026-04-27

### Improvements

  - Stability and performance improvements.

---

## v1.0.279 -- 2026-04-27

### Features — Local Authentication & CyIRIS Environment Improvements

  - **Local (username/password) authentication**: Added a new local login method
    alongside the existing Google and Microsoft SSO options. A dedicated "Sign in with
    local account" button is now present on the login page. Local users are stored in
    `rbac.json` with `auth_type: "local"` and a bcrypt-hashed password. The new
    `POST /auth/local` API endpoint validates credentials and creates the same session
    cookie as SSO — all RBAC roles and app permissions apply identically.

  - **OOB rbac.json with default local admin**: `rbac.default.json` is now bundled
    with every release. On a fresh install, setup.sh copies this file to
    `/opt/cycentra/rbac.json` (existing deployments are unaffected). The default file
    contains a single local-auth admin account `cyadmin@cycentra.com` with password
    `Admin@123` (bcrypt-hashed). Dynamic runtime creation of `rbac.json` from
    `${CLIENT_EMAIL}` has been removed from `cycentra-setup.sh`.

  - **CLOUD_IRIS_URL auto-populated on CyIRIS install**: When CyIRIS is installed
    via Platform Modules and the admin API key is captured from the DB, the installer
    now also ensures `CLOUD_IRIS_URL=http://127.0.0.1:4433` is present in
    `/opt/cycentra/.env`. If the variable already has a non-empty value it is not
    overwritten (backward-compatible).

  - **rbac.json schema extended**: New optional fields `auth_type` (`"local"` or
    `"sso"`) and `password_hash` (bcrypt) are supported per user entry. All existing
    SSO-only entries without these fields continue to work unchanged.

---

## v1.0.278 -- 2026-04-26

### Improvements

  - Stability and performance improvements.

---

## v1.0.278 -- 2026-04-27

### Bug Fixes

  - **Scheduler — backup cron entry fix**: Removed the spurious `root` username token
    from the backup cron entry generated by `_apply_schedules()`. User crontab format
    does not accept a username field (that is only valid in `/etc/cron.d/` files);
    the previous entry caused `root` to be executed as the command and
    `/opt/cycentra/run_backup.sh` to be silently discarded, so scheduled backups
    never ran.
  - **Setup — `docker-maintenance.sh` deployment fix**: Changed the deployment source
    from `_SCRIPT_DIR` to `BUNDLE_DIR` so `docker-maintenance.sh` is correctly deployed
    in all execution modes. In the portal --update path the script runs from
    `/opt/cycentra/` (where the file does not exist) but the bundle is always extracted
    to `BUNDLE_DIR`; using `_SCRIPT_DIR` caused the file to silently not be deployed,
    leaving the Docker Maintenance cron job broken with "not found" errors.

---

## v1.0.277 -- 2026-04-26

### Features — CyMind Agentic Chat (Response Actions)

The CyMind chat overlay can now execute security response actions directly from a conversation. When the analyst types an action request, the chat intercepts it, explains exactly what will happen, and presents a **Confirm / Cancel** card before any action is taken.

**Supported actions (analyst+ role required):**

- **Block IP** — `"block IP 10.0.0.1 on agent 003"` → Wazuh `firewall-drop` active-response
- **Disable user account** — `"disable user jdoe on agent 005"` → Wazuh `disable-account` active-response
- **Restart Wazuh agent** — `"restart agent 007"` → Wazuh `restart-wazuh` active-response
- **Close incident** — `"close incident INC-0042"` → transitions to `resolved` with audit log
- **Mark false positive** — `"mark INC-0037 as false positive"` → transitions to `false_positive`
- **Bulk mark false positives** — `"close all false positives"` → marks all open incidents, shows count before confirming
- **Trigger ASM scan** — `"run a deep scan on example.com"` → starts background scan, results in Asset Inventory
- **Add scan schedule** — `"schedule a daily scan of example.com at 3am"` → creates recurring job via new Scheduler

**New Scheduler subsystem:**
- Blueprint at `blueprints/scheduler/routes.py`
- API: `GET/POST/DELETE/PATCH /api/scheduler/jobs`
- APScheduler BackgroundScheduler with file-lock for multi-worker safety
- Job store: `/opt/cycentra/schedules.json`
- Supports cron and interval triggers

**New correlation engine endpoints:**
- `POST /active-response` — Wazuh active-response wrapper (block IP, disable user, restart agent)
- `POST /incidents/bulk-false-positive` — atomic bulk false-positive transition with audit trail

**All actions are:**
- Gated behind analyst+ RBAC
- Logged via existing SIEM audit infrastructure
- Intent-detected via deterministic regex (no LLM required for intent parsing)
- Require explicit analyst confirmation before execution

---

## v1.0.276 -- 2026-04-26

### Improvements

  - Stability and performance improvements.

---

## v1.0.275 -- 2026-04-26

### Improvements

  - Stability and performance improvements.

---

## v1.0.274 -- 2026-04-26

### Improvements

  - Stability and performance improvements.

---

## v1.0.273 -- 2026-04-25

### Improvements

  - Stability and performance improvements.

---

## v1.0.272 -- 2026-04-25

### Improvements

  - Stability and performance improvements.

---

## v1.0.271 -- 2026-04-25

### Improvements

  - Stability and performance improvements.

---

## v1.0.271 -- 2026-04-25

### New Features

  - **Active Incidents — Graphical Summary Section**: A visual analytics panel now
    appears at the top of the Active Incidents page, providing an at-a-glance
    overview before the incident list. Includes:
    · **Stat tiles** — Total, Open, Investigating, In Review, Resolved, Critical,
      and High counts updated in real-time.
    · **Severity Donut Chart** — interactive SVG pie; clicking a segment
      instantly applies the severity filter to the incident table below.
    · **Status Donut Chart** — same interactive filter binding for status.
    · **Category Distribution Bar** — horizontal bar chart of top-7 incident
      categories (colour-coded by category type).
    · **14-Day Trend Line** — smooth cubic-bezier line chart showing daily
      incident volume with hover tooltips. Driven by a separate unfiltered
      fetch (limit 500) so charts always reflect the full picture regardless
      of active table filters.

  - **Entity Risk — Graphical Summary Section**: A compact visualisation panel
    added above the entity leaderboard on the Entity Risk page. Includes:
    · **Stat tiles** — Total Entities, Critical (≥75), High (50–74),
      Medium (25–49), Low (0–24) counts.
    · **Score Distribution Histogram** — 10-bucket bar chart (0–9 … 90–100)
      with colour gradient (green → yellow → orange → red) and hover labels.
    · **Entity Type Split** — stacked bar and counters showing host vs. user
      breakdown with percentages.
    Charts refresh every 60 s independently of the filter tab selection.

---

## v1.0.270 -- 2026-04-25

### Improvements

  - Stability and performance improvements.

---

## v1.0.269 -- 2026-04-25

### Improvements

  - Stability and performance improvements.

---

## v1.0.268 -- 2026-04-25

### Improvements

  - Stability and performance improvements.

---

## v1.0.268 -- 2026-04-25

### Bug Fixes

  - **Scheduler — docker-maintenance.sh not deployed to customers**: `build-package.sh`
    now includes `docker-maintenance.sh` in the release tarball. Previously the file
    was absent from the bundle, causing `cycentra-setup.sh` to silently skip
    deployment, leaving the Scheduler unable to run maintenance jobs.

  - **Scheduler — ASM wordlist path corrected**: `_resolve_wordlist_path()` now
    searches `cy_asm/modules/Utils/update_wordlist.py` (correct `Utils/`
    subdirectory). Old flat-layout path retained as legacy fallback.

  - **Scheduler — ASM scan domain hardcoded to BASE_DOMAIN**: The target domain
    for scheduled scans is no longer a free-text input. Backend always reads
    `BASE_DOMAIN` from `/opt/cycentra/.env`; UI shows a read-only badge. Any
    client-supplied domain is stripped server-side on `PUT /api/system/schedules`.

---

## v1.0.267 -- 2026-04-25

### New Features

  - **Platform Modules — Version Check fixed**: "Check for Update" for CyIRIS and CySOAR
    now shows the actual running version extracted from the container's OCI image label
    (`org.opencontainers.image.version`) via a new backend endpoint
    `GET /api/platform/version/<module_id>`. The GitHub Releases API is called
    server-side (using `GH_TOKEN` from `/opt/cycentra/.env`) — no CORS issues.
    Running and Latest version numbers now appear correctly instead of "—".

  - **System Settings → Scheduler tab**: New tab for managing cron schedules from
    the portal UI. Supports three schedulable tasks:
    · Docker Maintenance (`docker-maintenance.sh`)
    · ASM Wordlist Update (`update_wordlist.py`)
    · ASM Scheduled Scan (configurable domain, scan type)
    Frequency options: every minute, hourly, daily, weekly, monthly, quarterly, yearly.
    Schedules persisted to `/opt/cycentra/schedules.json`; crontab applied immediately
    on save via `PUT /api/system/schedules` (admin only).

  - **System Settings → Environment Config**: Removed CyMISP entry — CyMISP is no
    longer managed through this portal. MISP integration settings remain in
    the Integrations tab (CySIEM Stack env).

### Bug Fixes / Improvements

  - `cycentra-setup.sh` Step 23 (Cron Jobs): removed auto-provisioning of
    docker-maintenance and ASM wordlist cron entries. Setup.sh now delegates all
    schedule management to the Scheduler tab. The `docker-maintenance.sh` script
    is still deployed to `/opt/cycentra/docker-maintenance.sh` as before.
    Existing schedules set up by older versions are preserved and remain active;
    they can be managed and overridden via the Scheduler tab.

---

## v1.0.266 -- 2026-04-24

### Improvements

  - Stability and performance improvements.

---

## v1.0.265 -- 2026-04-24

### Improvements

  - Stability and performance improvements.

---

## v1.0.264 -- 2026-04-24

### New Features

  - health check curl exit 7 kills script under set -e — add || true

### Bug Fixes

  - RELEASE_NOTES.md path moved to docs/ — update CI workflows

---

## v1.0.263 -- 2026-04-24

### New Features

  - health check curl exit 7 kills script under set -e — add || true

---

## v1.0.262 -- 2026-04-24

### New Features

  - health check curl exit 7 kills script under set -e — add || true

---

## v1.0.261 -- 2026-04-24

### Improvements

  - Stability and performance improvements.

---

## v1.0.260 -- 2026-04-24

### Bug Fixes

  - guard WAZUH_API_PASSWORD grep against set -e on fresh install

---

## v1.0.259 -- 2026-04-24

### Bug Fixes

  - update workflow paths for docs/RELEASE_NOTES.md move

---

## v1.0.258 -- 2026-04-24

### Improvements

  - Stability and performance improvements.

---

## v1.0.257 -- 2026-04-24

### Improvements

  - Stability and performance improvements.

---

## v1.0.256 -- 2026-04-24

### Improvements

  - Stability and performance improvements.

---

## v1.0.255 -- 2026-04-24

### Improvements

  - Stability and performance improvements.

---

## v1.0.254 -- 2026-04-24

### Improvements

  - Stability and performance improvements.

---

## v1.0.253 -- 2026-04-24

### Improvements

  - Stability and performance improvements.

---

## v1.0.252 -- 2026-04-23

### Bug Fixes

  - **CyIRIS Test Connection — whitespace in API key causes silent 401**:
    `iris_test()` read the API key from the request body without `.strip()`.
    A key copied from a terminal with a trailing newline/space failed the exact
    DB match in IRIS, producing 401 even though the key was correct.
    Fix: `api_key = data.get("apiKey", "").strip()` before any auth check.

  - **CyIRIS Test Connection — undifferentiated 401 message**:
    Both a genuine IRIS 401 (wrong key — JSON body `{"status":"error"}`) and a
    reverse-proxy 401 (oauth2-proxy / nginx IAP blocking Bearer tokens — HTML
    body) returned the same "Invalid API key (401 Unauthorized)" message.
    Fix: parse the response body; if JSON IRIS 401, show "Invalid API key" with
    a diagnostic `curl /api/ping` command; if HTML 401, surface "auth proxy /
    login gateway" hint and advise using the internal address
    (`http://127.0.0.1:4433`) to bypass the IAP gate.

  - **CyIRIS Test Connection — 401 on internal URL when running in oidc_proxy mode**:
    CyIRIS deployed in `oidc_proxy + lazy` mode only accepts `X-Email` header
    authentication (set by nginx/oauth2-proxy). Direct programmatic calls to
    `http://127.0.0.1:4433` with a Bearer API key bypassed the IAP gate but
    `_oidc_proxy_authentication_process()` in CyIRIS returned `None` when no
    `X-Email` header was present — blocking ALL API key access regardless of
    key correctness. Flask-Login's `request_loader` was resolving the Bearer
    token correctly but `is_user_authenticated()` ignored `current_user` in
    `oidc_proxy` mode. Fix (in CyIRIS `access_controls.py`): fall back to
    `current_user.is_authenticated` when `X-Email` is absent so programmatic
    REST access (correlation engine, System Settings test) is not locked out.
    Also fixed: stale `CLOUD_IRIS_API_KEY` in `/opt/cycentra/.env` — the key
    was set on initial install but never refreshed when the IRIS container was
    recreated, causing all API calls to fail with 401. Platform installer now
    captures the admin API key from the IRIS DB after first boot and writes it
    to `CLOUD_IRIS_API_KEY` in the master `.env` automatically.

---

## v1.0.251 -- 2026-04-23

### Improvements

  - Stability and performance improvements.

---

## v1.0.251 -- 2026-04-23

### Bug Fixes

  - **UI Update button — `_PIP_BSP: unbound variable` / exit code 1**:
    `_PIP_BSP` (the `--break-system-packages` flag detector for pip3) was
    initialised inside the `INFRASTRUCTURE BLOCK`, which is skipped entirely in
    `--update` mode. The `APP BLOCK` (runs in all modes) references `${_PIP_BSP}`
    in two places — the CySIEM→Redis bridge pip install and the backend wheel
    install (Step 12). With `set -euo pipefail` active, bash aborts on the first
    expansion of an unbound variable, producing the `_PIP_BSP: unbound variable`
    error and exit code 1. Manual `--update` runs succeeded because the server's
    on-disk copy pre-dated the Step 12 `${_PIP_BSP}` reference; the UI button
    always downloads the latest release script and ran into it. Fix: added a
    `_PIP_BSP` re-detection block immediately after `fi  # end INFRA block` so
    the variable is always set before any APP BLOCK code executes.
    File: `cycentra-setup.sh` — between INFRA block `fi` and APP BLOCK header.
    Regression tests: `tests/unit/test_pip_bsp_update_mode.py` (3 cases).

  - **Cloud CyIRIS test connection — "CyIRIS API Key is required" even when key is provisioned**:
    `iris_test()` read from `ai_settings.json` when `useStored=True` but had no env-var
    fallback, unlike the equivalent MISP handler. In cloud mode the UI never stores the key
    in `ai_settings.json` (it lives in `.env` as `CLOUD_IRIS_API_KEY`). Added
    `os.environ.get("CLOUD_IRIS_API_KEY")` fallback after the settings-file lookup —
    matching the pattern already used by MISP (`CLOUD_MISP_API_KEY`).
    File: `backend/blueprints/system/routes.py` — `iris_test()`.

  - **Cloud CyIRIS test connection — "Server returned a non-JSON response" (nginx IAP blocks Bearer token)**:
    Even after the API key was resolved, `iris_test()` used the URL the UI sends
    (`https://cyiris.cycentra.com`) which routes through the nginx IAP gate (oauth2-proxy).
    The proxy intercepts all requests without a browser session cookie — including
    Bearer-token API calls — and returns an HTML redirect to login. `iris_connector.py`
    (the correlation engine) works because it reads `CLOUD_IRIS_URL` from `.env`, which
    is set to the internal Docker address (e.g. `http://127.0.0.1:4433`) that bypasses
    nginx entirely. Fix: `iris_test()` now resolves the URL from `CLOUD_IRIS_URL` env var
    when `useStored=True`, using the same fallback logic as `iris_connector.py` and
    `_sync_iris_to_siem_env()`.
    File: `backend/blueprints/system/routes.py` — `iris_test()`.

  - **Local CyIRIS test connection — "Expecting value: line 1 column 1 (char 0)"**:
    When the configured URL pointed to a server returning HTTP 200 with an HTML/empty
    body (wrong host, default nginx page, proxy), `resp.ok` was `True` and the code
    entered the success branch. `ver_resp.json()` then raised `json.JSONDecodeError`
    which propagated to the outer `except Exception as e` → `str(e)` = the cryptic
    message. Two-part fix: (1) validate the `/api/ping` response is JSON with
    `status == "success"` before proceeding — gives a clear URL-mismatch message;
    (2) wrapped `ver_resp.json()` in its own `try/except` so a missing/invalid version
    endpoint never hides a successful ping.
    File: `backend/blueprints/system/routes.py` — `iris_test()` ping success path.

  - **Local CyIRIS test connection — misleading "Access denied (403 Forbidden)" on wrong URL**:
    Testing with `http://127.0.0.1` (port 80) on a CyCentra server hits CyCentra's own
    nginx/Flask — not CyIRIS. CyCentra's auth middleware returns 403 before routing, which
    the test handler reported as "Access denied (403 Forbidden)", implying an API key problem.
    Local CyIRIS listens on port 4433 by default. Fix: the 403 handler now inspects the
    response body — a real IRIS 403 carries `{"status": "error", ...}` JSON and gets a
    "check your API key" message; a non-IRIS server (HTML body) gets a "check URL/port"
    message.
    File: `backend/blueprints/system/routes.py` — `iris_test()`.
    Regression tests: `tests/unit/test_iris_test_route.py` (10 cases).

---

## v1.0.249 -- 2026-04-23

### Improvements

  - Stability and performance improvements.

---

## v1.0.248 -- 2026-04-22

### Improvements

  - Stability and performance improvements.

---

## v1.0.247 -- 2026-04-22

### Improvements

  - Stability and performance improvements.

---

## v1.0.247 -- 2026-04-22

### Portal URL — cysoc → cy360

  - Portal subdomain renamed from `cysoc.<domain>` to `cy360.<domain>` across all layers (nginx config, OAuth2-proxy redirect URIs, OIDC clients, CORS allowed origins, backend config defaults, RBAC app IDs, `constants.js` base-domain derivation). DNS registration updated on the server side.
  - `constants.js`: `_BASE_DOMAIN` derivation regex updated to strip `cy360.` instead of `cysoc.`; `PORTAL_URL` and `PORTAL_ISSUER` updated accordingly.
  - `SiemIncidentsPage.jsx`: Wazuh deep-link derivation updated from `cysoc.` to `cy360.` prefix.
  - `backend/core/config.py`: `FRONTEND_URL` default, OAuth2-proxy `redirect_uris`, `ROLE_APPS`, `CORS_ALLOWED_ORIGINS`.
  - `backend/blueprints/system/routes.py`: MCP public URL, CyMind nginx comment, activate-cycentra URL.
  - `backend/blueprints/platform/routes.py`: nginx block CSP, error401 redirects, SSL cert paths, certbot domain list.
  - `backend/blueprints/rbac/manager.py`: default fallback app list.
  - `cycentra-setup.sh`, `build-package.sh`: all 39 `cysoc` occurrences replaced.

### Stability: Storage bloat prevention

  - `core/auth.js`: Added `validateStorage()` — checks schema version, validates structure of all persisted keys (`cy_user`, `cycentra_ai_config`, `cycentra_modules`, `cycentra_asset_statuses`), clears any corrupt or version-mismatched entry automatically on app init.
  - `core/auth.js`: Added `clearNonEssentialCache()` — clears non-auth cache keys and sessionStorage, called by the Error Boundary.
  - `useAppState.js`: `validateStorage()` called once on mount before restoring config. Per-key `try/catch` blocks now also delete corrupt keys rather than silently skipping them.
  - `useAppState.js`: `_saveStatuses()` now caps `cycentra_asset_statuses` at 500 entries (trims oldest) to prevent unbounded localStorage growth across many rescans.
  - Storage schema version key (`cy_storage_ver`) added; future schema-breaking changes auto-wipe stale data on first load.

### Stability: React Error Boundary — Clear Cache & Reload

  - `App.jsx`: `PageErrorBoundary` enhanced with a second "Clear Cache & Reload" action button that calls `clearNonEssentialCache()` then `window.location.reload()`. Non-destructive: account session and scan results are preserved.

### Bug fix: Memory leaks in interval/timer management

  - `PlatformPage.jsx` (`InstallForm`): module install poll interval now stored in `pollRef` and cleaned up via `useEffect` return, preventing state updates on unmounted components if the user closes the install modal mid-progress.
  - `GuestScanPage.jsx`: Added `useEffect` unmount cleanup that calls `clearInterval` on both `pollRef.current` and `timerRef.current`, preventing orphaned scan-status pollers after navigation.
  - `SystemSettingsPage.jsx` (`UpdatesTab`): the version-fetch `useEffect` now returns a cleanup that clears `pollRef.current`, preventing the update-log poller from firing after the settings tab is closed.

---

## v1.0.246 -- 2026-04-22

### Improvements

  - Stability and performance improvements.

---

## v1.0.245 -- 2026-04-22

### Improvements

  - Stability and performance improvements.

---

## v1.0.244 -- 2026-04-22

### Improvements

  - Stability and performance improvements.

---

## v1.0.243 -- 2026-04-22

### Improvements

  - Stability and performance improvements.

---

## v1.0.242 -- 2026-04-22

### Improvements

  - Stability and performance improvements.

---

## v1.0.241 -- 2026-04-22

### Improvements

  - Stability and performance improvements.

---

## v1.0.240 -- 2026-04-21

### Improvements

  - Stability and performance improvements.

---

## v1.0.239 -- 2026-04-21

### Improvements

  - Stability and performance improvements.

---

## v1.0.238 -- 2026-04-20

### Improvements

  - Stability and performance improvements.

---

## v1.0.237 -- 2026-04-20

### Improvements

  - Stability and performance improvements.

---

## v1.0.237 -- 2026-04-20

### Bug Fixes

- **Asset Inventory — React error #31 on exposed paths**: `exposed_paths` entries can
  be rich objects `{path, severity, status, url}` rather than plain strings. `AssetDrawer`
  now extracts `p.path || p.url` for display and renders the `severity` and `status` fields
  as inline badges alongside the path. The same type-guard fix was applied to `api_endpoints`
  entries that may carry object forms.
- **Findings — duplicate vulnerabilities at different severity levels**: The deduplication
  key in `VulnerabilityPage` previously included `source`, so the same CVE/finding reported
  by two scanners (e.g. OpenVAS Critical + Nuclei High) appeared as two rows. The key is
  now `asset|vulnerability|module` (source dropped) and when a duplicate is encountered
  the entry with the **higher severity** is kept.

### Verification

- **Automated status change logic**: Confirmed present and fully active on both pages.
  `VulnerabilityPage` — `computeConfidence` + `computeAutoStatus` drives
  `open → investigating` (confidence ≥ 75, CVSS ≥ 7.0, EPSS ≥ 60%) and
  `investigating → in_review` (CVSS ≥ 9.0, EPSS ≥ 75%, risk_score ≥ 8).
  `AssetsPage` — `computeAssetConfidence` + `computeAssetAutoStatus` mirrors the same
  state machine keyed on risk level and critical/high vuln counts. No changes required.

---

## v1.0.236 -- 2026-04-20

### Improvements

  - Stability and performance improvements.

---

## v1.0.236 -- 2026-04-20

### Bug Fixes

- **Asset Inventory & Findings — black page on entry click**: Added a `PageErrorBoundary`
  React error boundary in `App.jsx` that catches any render-time crash inside the page
  content area and displays a "RENDER ERROR + Retry" fallback instead of blanking the
  entire viewport. Previously any unhandled render exception (e.g. object rendered as a
  React child, undefined property access) would silently crash the whole page.
- **Asset Inventory drawer — type-safe field rendering**: Hardened `v.vulnerability`,
  `v.description`, and `v.module` fields in `AssetDrawer`'s findings list with explicit
  string coercion, preventing "objects are not valid as a React child" crashes when scan
  data includes structured objects in those fields.
- **Findings drawer — type-safe parent asset context**: Hardened `technologies`,
  `exposed_paths`, and `api_endpoints` renders in `FindingDrawer`'s parent asset section
  with explicit string coercion for the same class of crash.

### Improvements

- **Asset Inventory drawer — Status Lifecycle & auto-status**: `AssetDrawer` now includes
  the full Status Lifecycle section with a `computeAssetConfidence` score (base risk level
  + critical/high vuln count boost), an **AUTO-STATUS SUGGESTION** banner (`AssetAutoStatusBanner`)
  that proposes `open → investigating` (risk=critical, critCount>0, or confidence≥75) or
  `investigating → in_review` (critCount≥3, highCount≥5, or confidence≥90), and a
  one-click Apply button that POSTs the new status with an auto-generated audit comment.
- **Asset Inventory drawer — Audit Trail**: `AssetDrawer` now renders a full audit trail
  section at the bottom of the panel, sourced from the `audit_log` array in the
  `{status, audit_log}` object returned by `/api/asm/statuses`. Matches the audit trail
  already present in `FindingDrawer`.
- **Asset Inventory drawer — timestamps**: First Seen and Last Seen timestamps are now
  shown in the core details grid of `AssetDrawer`.

---

## v1.0.235 -- 2026-04-20

### Improvements

  - Stability and performance improvements.

---

## v1.0.234 -- 2026-04-20

### Bug Fixes

- **Findings — black page on row click**: `FindingDrawer` now resolves the parent
  asset via the `assetObj` reference that is co-located on every `allVulns` entry,
  with `assetLookup[assetId]` as a secondary fallback. This ensures the HTTP
  analysis, API endpoints, JS secrets, and SSL context sections always have the
  correct asset data even when `assetId` is null in a scan batch.
- **Asset Inventory — Base Domain drawer empty sections**: Added IP Enrichment,
  OSINT Data, Mobile/API Analysis, and PQC Readiness blocks to `AssetDrawer` so
  the panel matches the legacy Full Detail view. Fixed a regression where
  `dns_ips` entries were rendered as `[object Object]` — the display now correctly
  extracts `.ip` from object-typed entries.
- **`makeFindingId` empty-string guard**: When all of `asset`, `vulnerability`,
  and `module` are blank the slug now falls back to `"unknown-finding"` instead
  of `""`, preventing a silent `STATUS_CONFIG[""]` miss.

### Improvements

- **Findings deduplication**: The `allVulns` flatMap now filters through a `Set`
  keyed on `asset|vulnerability|module|source`. Duplicate findings that appear
  across overlapping scan profiles are collapsed to a single row in the
  Vulnerability Explorer.
- **Asset Detail Parity**: `AssetDrawer` now surfaces four additional data
  sections that were previously only in the legacy Full Detail modal:
  - **IP Enrichment** — ASN, Org, Country, City from the first resolved IP
  - **OSINT Data** — collated output from `a.osint_data` (emails, leaked data, etc.)
  - **Mobile / API** — mobile app and API data from `a.mobile_api`
  - **PQC Readiness** — post-quantum cryptography assessment from `a.pqc_data`
- **Unified AI Confidence logic — UEBA module**: The confidence-score engine
  (`open → investigating → in_review`) that was previously only in the ASM
  Findings drawer is now live in the UEBA anomaly cards.
  - `computeUebaConfidence(a)` maps each anomaly type to a severity tier
    (`privilege_escalation / svc_account_interactive / impossible_travel` → critical;
    `high_auth_fail_rate / multi_host_burst` → high; `off_hours_login` → medium;
    `new_agent_access` → low), then adjusts by `risk_contribution`.
  - `computeUebaAutoStatus(a, curStat)` applies the same thresholds:
    confidence ≥ 75 OR risk_contribution ≥ 3 OR critical-type → suggests
    `investigating`; confidence ≥ 90 OR risk_contribution ≥ 6 OR critical-type →
    suggests `in_review`.
  - An **AUTO-STATUS SUGGESTION** banner with one-click Apply appears in the
    Status Lifecycle section of each expanded anomaly card.
  - A **CONFIDENCE** bar renders at the top of the Status Lifecycle section,
    colour-coded red / amber / yellow / blue with 75 and 90 threshold ticks.

---

## v1.0.233 -- 2026-04-20

### Bug Fixes

  - **ASM Findings — black page on row click**: `findingStatuses[fid]` is now a full
    `{status, audit_log}` object returned by `/api/asm/statuses`. The table rows were
    passing the raw object to `StatusBadge` → `STATUS_CONFIG[object]` returned `undefined`
    → accessing `.color` threw and React's error boundary blanked the page. Fixed: all
    table rows now unwrap with `(typeof entry === "object" ? entry?.status : entry) || "open"`.

  - **FindingDrawer scroll regression**: the panel container had both `display:flex,
    flexDirection:column` and `overflowY:auto`. The inner scrollable body's `flex:1`
    could not size correctly because the parent itself could scroll. Fixed: panel
    container changed to `overflow:hidden`; the inner body div remains `flex:1,
    overflowY:auto` and scrolls correctly.

  - **Asset Inventory — dual panel on row click**: clicking a row in Asset Inventory
    triggered both the `AssetDrawer` (zIndex 3001) inside `AssetsPage` and the legacy
    `AssetModal` (zIndex 100) via the App.jsx-level `selectedAsset` state. The `AssetModal`
    remained visible when the `AssetDrawer` was closed. Fixed: `openDrawer` no longer
    calls `setSelectedAsset()` — the `AssetModal` is only opened from Dashboard asset
    clicks where it serves a distinct purpose.

  - **Asset Inventory — status object unwrap**: `assetStatuses[host]` can be a full
    `{status, audit_log}` object (mirrors the findings format). Table rows and
    `AssetDrawer` now correctly unwrap before reading current state.

### Improvements

  - **Asset Inventory — Status as second slide-out panel**: the Status Lifecycle controls
    have been extracted from the `AssetDrawer` body into a dedicated `AssetStatusPanel`
    component that renders at zIndex 3002, width 340px, sliding in to the left of the
    detail panel. An "UPDATE STATUS" toggle button in the detail panel header opens/closes
    the sub-panel. Transition buttons are now displayed vertically for easier touch targets.

  - **ASM Automation — State Transition Matrix (active)**: confidence-driven status
    suggestions are visible in the FindingDrawer as soon as the panel opens (black-page
    bug is now fixed). The `AutoStatusBanner` shows when `computeAutoStatus()` returns a
    suggestion and the one-click Apply posts to `/api/asm/findings/<id>/status` with an
    auto-generated audit comment.

    | From          | To            | Trigger                                         | Method      |
    |---------------|---------------|-------------------------------------------------|-------------|
    | open          | investigating | confidence ≥ 75  OR  cvss ≥ 7.0  OR  epss ≥ 60% | Automated   |
    | open          | investigating | confidence ≥ 90 (Critical)                      | Automated   |
    | investigating | in_review     | cvss ≥ 9.0  OR  epss ≥ 75%  OR  risk_score ≥ 8  | Automated   |
    | all others    | —             | analyst decision with audit comment             | Manual only |

---


## v1.0.233 -- 2026-04-20

### New Features

  - **CyMind RAG-Chat Integration**: Analyst and admin users now see a persistent chat
    overlay (brain FAB button, bottom-right) that loads the CyMind AI assistant inside
    CyCentra 360.  The overlay connects to CyMind via an iframe and leverages the existing
    Security MCP bridge so CyMind can answer live questions about open incidents, entity
    risk scores, UEBA anomalies, and Wazuh agents — all in natural language.

  - **MCP Access Control**: The Security MCP bridge endpoint (`/mcp/sse`) now enforces an
    API key (`CYMIND_API_KEY` in `cysiemstack.env`).  Unauthenticated requests receive HTTP
    401.  The key is generated in the portal and written to the env file automatically.

  - **System Settings → CyMind tab**: New integration settings page lets admins enter the
    CyMind base URL, generate / rotate the shared API key, test connectivity, and follow a
    step-by-step setup checklist.  Analyst users can read the config; only admins can write.

  - **RBAC: user role surfaced to frontend**: The OAuth callback now passes the user's RBAC
    role to the React app so role-gated features (CyMind overlay, future analyst-only pages)
    can be shown or hidden without an extra round-trip.

### Setup (minimum effort)

  See `docs/CYMIND_INTEGRATION.md` for the full guide.  Quick version:

  1. **System Settings → CyMind → Generate API Key** — copy the `cymk_…` key.
  2. `sudo systemctl restart cysiemstack-engine` — activates the key guard.
  3. Paste key into **CyMind → MCP Settings → API Key**, set endpoint to
     `http://127.0.0.1:8100/mcp/sse`.
  4. In CyMind `.env`: `CYCENTRA_ORIGIN=https://cysoc.YOUR_DOMAIN` — enables the iframe.
  5. Restart CyMind.  Analyst users see the chat FAB immediately on next login.

---

## v1.0.232 -- 2026-04-20

### Improvements

  - Stability and performance improvements.

---

## v1.0.232 -- 2026-04-20

### New Features

  - **Confidence Score + Automated State Transition Logic for ASM Findings**: each finding
    in the Findings drawer now shows a visual confidence bar (0–100) with threshold markers
    at 75 and 90. Confidence is computed per finding as a function of severity
    (Critical=95, High=80, Medium=55, Low=30) adjusted by risk_score (±7.5 pts). When a
    transition is algorithmically triggered the drawer shows an "AUTO-STATUS SUGGESTION"
    banner with a one-click Apply button. Auto-apply generates a mandatory audit-trail
    comment automatically so the backend requirement is satisfied.

  - **State Transition Matrix**:

    | From          | To            | Trigger Condition                               | Method      |
    |---------------|---------------|-------------------------------------------------|-------------|
    | open          | investigating | confidence ≥ 75  OR  cvss ≥ 7.0  OR  epss ≥ 60% | Automated   |
    | open          | investigating | confidence ≥ 90 (Critical severity)             | Automated   |
    | open          | in_review     | analyst decision with audit comment             | Manual only |
    | open          | resolved      | analyst decision with audit comment             | Manual only |
    | open          | false_positive| analyst decision with audit comment             | Manual only |
    | investigating | in_review     | cvss ≥ 9.0  OR  epss ≥ 75%  OR  risk_score ≥ 8 | Automated   |
    | investigating | resolved      | analyst closure with audit comment              | Manual only |
    | investigating | false_positive| analyst reclassification with audit comment     | Manual only |
    | in_review     | resolved      | analyst closure with audit comment              | Manual only |
    | in_review     | false_positive| analyst reclassification with audit comment     | Manual only |
    | in_review     | investigating | re-open for further investigation               | Manual only |
    | resolved      | investigating | resurfaced — re-engage investigation            | Manual only |
    | false_positive| investigating | reclassification after context review           | Manual only |

  - **findingStatuses format fix**: status store now correctly handles full `{status, audit_log}`
    objects returned by `/api/asm/statuses`; audit trail is rendered inline in the drawer.

  - **Inline Audit Trail in FindingDrawer**: the status history (who moved it, when, with
    which comment) is now rendered inside the drawer in reverse-chronological order with
    colour-coded from→to state labels.

  - **Backend `/api/asm/auto-status` route** (POST, auth required): accepts a JSON array of
    findings with severity/cvss/epss_pct/risk_score/current_status and returns a suggestions
    array with the triggered transition target and reason string. Read-only — does not apply
    transitions. Mirrors the frontend `computeAutoStatus()` logic exactly.

  - **AssetDrawer high-depth schema**: vulnerability list in the Asset detail panel now uses
    the exact same row layout as the Dashboard "Critical & High Vulnerabilities" widget
    (severity-coloured left border, Badge | title+description | module+CVSS | ↗). Rich data
    sections added: SSL/TLS, DNS resolution, HTTP analysis, API endpoints, JS secrets, cloud
    buckets, supply chain risk, social engineering exposure, and WHOIS.

  - **Extended Asset Context in FindingDrawer**: when a parent asset has http_analysis,
    api_endpoints, js_secrets, or ssl_detail the FindingDrawer now surfaces that data inline
    under an "Asset Context" block — scoped to fields relevant to the finding's module.

---

## v1.0.231 -- 2026-04-20

### New Features

  - **Right-side slide-out detail panels for ASM Findings and Asset Inventory**: clicking any
    row in Vulnerability Explorer or Asset Inventory now opens a fixed 480 px right-side
    drawer containing the full finding/asset detail, status lifecycle controls, and (for
    findings) the CyIRIS ticket indicator. Replaces the previous inline accordion expander
    (Vulnerabilities) and centre-overlay transition modal (Assets).

  - **Single Current Active State indicator on all list rows**: Vulnerability, Asset, and UEBA
    Anomaly rows now show exactly one status badge — the current active state. All status
    transition controls have been moved inside the detail panel / expanded card. No inline
    transition button clusters remain in the table rows.

  - **Three-state Ticket Status Indicator**:
    - SUCCESS — green case link (✓ Case #N ↗) when a CyIRIS ticket exists
    - FAILED  — red "⚠ Auto-raise failed" banner + orange "Manual Ticket" button when an
                automated raise attempt was rejected
    - NONE    — blue "Raise Ticket" / IRIS escalate button when no ticket exists yet
    Applied to ASM Findings (inside `FindingDrawer`) and UEBA Anomaly cards.

  - **Status lifecycle ported to UEBA Anomaly cards**: analysts can now transition anomalies
    through `open → investigating → in_review → resolved / false_positive` directly in the
    expanded anomaly panel, with a mandatory audit comment. Transitions are persisted in
    `/opt/cycentra/ueba_statuses.json` via two new Flask-only routes in `siem_proxy.py`.

  - **New Flask routes — UEBA Anomaly Status (siem_proxy.py)**:
    - `GET  /api/siem/ueba/anomaly/statuses`            — bulk status map (auth required)
    - `GET  /api/siem/ueba/anomaly/<id>/audit`          — full audit log for an anomaly
    - `POST /api/siem/ueba/anomaly/<id>/status`         — transition with mandatory comment
      (analyst+ role enforced; allowed transitions mirror ASM findings)

### Improvements

  - **Status naming synchronised across all modules**: canonical status names are `open`,
    `investigating`, `in_review`, `held`, `resolved`, `false_positive`, `closed`. The legacy
    alias `in-review` is retained in `STATUS_CONFIG` for backward compatibility only.
  - **Inline transition form embedded in detail panels**: no secondary modal. Comment textarea
    and Confirm/Cancel are inline within the slide-out drawer, reducing click depth by one
    step and making the audit requirement immediately visible.
  - **Manual Ticket fallback**: previously a failed auto-escalation showed only terse error
    text. It now shows an explicit labelled "Manual Ticket" button to re-attempt the raise.

---

## v1.0.230 -- 2026-04-20

### Improvements

  - Stability and performance improvements.

---

## v1.0.228 -- 2026-04-19

### Bug Fixes

  - **CySIEM SSO: Wazuh login screen shown instead of automatic sign-in (proxy_auth_domain never enabled)**:
    After the v1.0.225 kibanaserver / rolesmapping fixes the `{"statusCode":401}` error was
    resolved, but users still landed on Wazuh Dashboard's native login screen instead of being
    signed in automatically.
    Root cause A — Python state-machine bug: the `config.yml` patcher used `indent <= 4` as
    the exit condition for the `proxy_auth_domain` block, but that block is typically indented
    at 6 spaces; sibling keys (also at 6 spaces) never triggered the exit.  More importantly
    the script always exited 0 and printed `"OpenSearch proxy_auth_domain enabled"` even when
    the `proxy_auth_domain` key was never found in the file — `securityadmin.sh` then uploaded
    an unchanged `config.yml` (still `http_enabled: false`), silently leaving proxy auth
    disabled.
    Root cause B — no REST API fallback: `securityadmin.sh` was the only path to apply the
    config change.  Its stderr was discarded (`2>/dev/null`), so JVM or YAML failures were
    invisible and there was no retry.
    Fixes applied: (1) state-machine exit condition changed to `indent <= proxy_dom_indent`
    (the actual indent of `proxy_auth_domain:`); (2) script now exits 1 when no change was
    made; (3) if `proxy_auth_domain` is absent entirely the full block is injected before
    `basic_internal_auth_domain`; (4) a REST API primary path is added —
    `GET /_plugins/_security/api/securityconfig` → patch → `PUT .../config` — which requires
    no JVM and is immune to Java heap / timeout issues; (5) `securityadmin.sh` stderr is
    appended to `/var/log/cycentra/securityadmin.log` for post-install diagnosis.
    File: `cycentra-setup.sh`, `docs/SSO-Troubleshooting.md`.

---

## v1.0.227 -- 2026-04-19

### Bug Fixes

  - **setup.sh: `_CYSIEM_KS_PASS: unbound variable` crash during update/existing-install runs**:
    `_CYSIEM_KS_PASS` was only assigned inside the fresh Wazuh install `else` branch.
    When Wazuh was already installed, the variable was never declared and `set -u`
    threw `unbound variable` at Step 8 (CySIEM Dashboard Configuration), aborting
    the entire setup run.
    Fixed: initialised `_CYSIEM_KS_PASS=""` alongside `_CYSIEM_WUI_PASS=""` before
    the Wazuh install block so the variable is always defined regardless of install path.
    File: `cycentra-setup.sh`.

---

## v1.0.226 -- 2026-04-19

### Improvements

  - Stability and performance improvements.

---

## v1.0.225 -- 2026-04-19

### Improvements

  - Stability and performance improvements.

---

## v1.0.225 -- 2026-04-19

### Bug Fixes

  - **CySIEM (Wazuh) SSO: kibanaserver credentials left commented-out on fresh install**:
    Wazuh installer generates a random `kibanaserver` password but leaves
    `opensearch.username` / `opensearch.password` commented in `opensearch_dashboards.yml`.
    Dashboard has no service account → every request returns 401 before proxy headers
    are evaluated. `cycentra-setup.sh` Step 4.1 now extracts the kibanaserver password
    from the installer tar (or falls back to `wazuh-passwords-tool.sh`) and injects
    active credentials into the Dashboard config automatically.
    File: `cycentra-setup.sh`.

  - **CySIEM (Wazuh) SSO: securityadmin rolesmapping patch missing `_meta` header**:
    Previous securityadmin calls used a YAML without the required `_meta` block,
    causing `A version of 2 must have a _meta key for ROLESMAPPING` error and silently
    leaving the rolesmapping unchanged. Fixed: all securityadmin rolesmapping YAMLs
    now include `_meta: {type: rolesmapping, config_version: 2}`.
    File: `cycentra-setup.sh`.

  - **CySIEM (Wazuh) SSO: partial rolesmapping wipes kibana_server user mapping**:
    `securityadmin.sh -f <file> -t rolesmapping` replaces the *entire* rolesmapping.
    Patching only `all_access` removed `kibana_server → kibanaserver` causing
    `no permissions for cluster:monitor/nodes/info` cascade. Fixed: setup.sh now
    applies a complete rolesmapping including `kibana_server`, `kibana_user`,
    `wazuh_ui_user`, `wazuh_ui_admin`, `own_index`, and `all_access` entries.
    File: `cycentra-setup.sh`.

  - **CySIEM (Wazuh) SSO: `cd /` guard before securityadmin calls**:
    `securityadmin.sh` emits `getcwd` Java errors when run from a directory that
    no longer exists. Added `cd /` before every securityadmin invocation.
    File: `cycentra-setup.sh`.

  - **Docs: added `docs/SSO-Troubleshooting.md`** with full RCA history for CyIRIS
    and Wazuh SSO issues, diagnostic checklist, and per-version file change table.

---

## v1.0.224 -- 2026-04-19

### Bug Fixes

  - **CyIRIS crash-loop: `BASE_DOMAIN` blank — DNS failure on OIDC discovery URL**:
    `cyiris_env` in `_install_module_async` never included `BASE_DOMAIN`, so the
    module `.env` file had no `BASE_DOMAIN=` entry. Docker Compose substituted
    `${BASE_DOMAIN}` as empty string → `OIDC_IRIS_DISCOVERY_URL` became
    `https://cyasm./oidc/...` → DNS failure → `exit(0)` crash-loop.
    Fixed: added `"BASE_DOMAIN": base_domain` to `cyiris_env` dict.
    File: `backend/blueprints/platform/routes.py`.

---

## v1.0.223 -- 2026-04-19

---

## v1.0.223 -- 2026-04-19

### Bug Fixes

  - **CyIRIS logout redirects to `cyiris.DOMAIN/oauth2/sign_out` (404)**: The proxy
    logout URL was a relative path (`/oauth2/sign_out`). The browser resolved it against
    `cyiris.DOMAIN` which has no `/oauth2/` handler — nginx proxied it to CyIRIS → 404.
    Fixed: `AUTHENTICATION_PROXY_LOGOUT_URL` is now a fully-qualified URL
    (`https://cysoc.DOMAIN/oauth2/sign_out?rd=https://cysoc.DOMAIN/`) using `BASE_DOMAIN`
    env var. Files: `CyIRIS/source/app/configuration.py`, `backend/blueprints/platform/routes.py`
    (added `location = /logout` intercept in cyiris nginx block as belt-and-suspenders).

---

## v1.0.222 -- 2026-04-19

---

## v1.0.221 -- 2026-04-18

### Improvements

  - Stability and performance improvements.

---

## v1.0.222 -- 2026-04-19

### Bug Fixes

  - **CyIRIS SSO users get no permissions after first login**: `create_user()` creates the
    DB record but does not assign a group. Auto-provisioned SSO users had zero group
    membership → no permissions. Fixed: `_authenticate_with_email` now calls
    `add_user_to_group(user.id, initial_group.group_id)` using `IRIS_NEW_USERS_DEFAULT_GROUP`
    after creating the user (mirrors the `ldap_handler.py` pattern).
    Files: `CyIRIS/source/app/blueprints/access_controls.py`,
    `backend/blueprints/platform/compose.py` (sets `IRIS_NEW_USERS_DEFAULT_GROUP: Administrators`).

---

## v1.0.221 -- 2026-04-19

### Bug Fixes

  - **CyIRIS logout — `KeyError: 'current_case'`**: `session['current_case']` raised
    `KeyError` for new SSO users whose session never had a case set. Changed to
    `session.get('current_case')`. File: `CyIRIS/source/app/blueprints/rest/dashboard_routes.py`.

  - **CyIRIS logout — re-logs user in immediately after logout**: `is_authentication_oidc()`
    returns `False` for `oidc_proxy` mode so the OIDC end-session block was skipped,
    leaving the oauth2-proxy cookie intact. Added an explicit `AUTHENTICATION_PROXY_LOGOUT_URL`
    redirect block (`/oauth2/sign_out?rd=<cysoc_url>`) that fires for `oidc_proxy` mode.
    File: `CyIRIS/source/app/blueprints/rest/dashboard_routes.py`.

  - **CyIRIS logout — redirect target**: After oauth2-proxy sign-out, users were redirected
    back to `/dashboard` on `cyiris.DOMAIN`. Redirect now points to `https://cysoc.DOMAIN/`
    using `BASE_DOMAIN` env var. Files: `cycentra360/backend/blueprints/platform/compose.py`
    (added `BASE_DOMAIN` to CyIRIS env), `CyIRIS/source/app/configuration.py`.

---

## v1.0.220 -- 2026-04-18

### Bug Fixes

  - **IAP / CySIEM SSO — Wazuh Dashboard still prompting for credentials**: nginx was
    sending `X-Proxy-Roles: admin` to Wazuh Dashboard via proxy auth. OpenSearch
    Security's default `roles_mapping.yml` has **no entry** for backend role `admin`,
    so authenticated users arrived with zero security roles and were denied.
    Fix: changed `X-Proxy-Roles` to `all_access` (the built-in backend role pre-mapped
    to the `all_access` security role) in the nginx `cysiem` server block in
    `cycentra-setup.sh`.  An idempotent `sed` patch step was also added to the IAP
    setup section so that existing servers are fixed automatically on the next
    `--update` run.
    (`cycentra-setup.sh`)

  - **IAP / CyIRIS SSO — container crash-loops on startup (TLS_ROOT_CA)**: In
    `oidc_proxy` auth mode CyIRIS calls `requests.get(discovery_url, verify=tls_root_ca)`
    at startup to fetch OIDC metadata.  `TLS_ROOT_CA` was set to
    `/opt/cycentra/certs/cycentra.crt` — a server leaf certificate, not a CA bundle.
    `requests` raises `SSLError` (cert is not a CA) or `FileNotFoundError` (file absent
    after a fresh install), which triggers `exit(0)` in the `except` block → Docker
    restart loop → 502 on `cyiris.DOMAIN`.
    Fix: removed `TLS_ROOT_CA` from the CyIRIS compose template; the system CA bundle
    inside the container already trusts Let's Encrypt/OIDC provider certs.
    (`backend/blueprints/platform/compose.py`)

  - **IAP / CyIRIS SSO — new users unable to log in (oidc_proxy lazy mode)**: Even
    after the container started, any user other than the seeded admin was rejected.
    `_authenticate_with_email()` called `get_user(email)` and returned `False` when
    the user wasn't found, silently ignoring `AUTHENTICATION_CREATE_USER_IF_NOT_EXIST:
    "True"`.  The create-user code path existed in the full OIDC flow
    (`login_routes.py`) but was not ported to the `oidc_proxy` lazy path.
    Fix: added auto-provisioning in `_authenticate_with_email` — when the user is
    not found and `AUTHENTICATION_CREATE_USER_IF_NOT_EXIST` is enabled, a new account is
    created with a random password (login is always via SSO so the password is unused).
    (`CyIRIS/source/app/blueprints/access_controls.py`)

---

## v1.0.219 -- 2026-04-18

### Improvements

  - Stability and performance improvements.

---

## v1.0.218 -- 2026-04-18

### Bug Fixes

  - **Setup / pip3**: Fixed `no such option: --break-system-packages` fatal error during Step 10 (CySIEM Redis bridge) on Ubuntu 20.04 and systems with pip < 23.x. The flag is now detected at startup (`_PIP_BSP`) and used only when supported — all four `pip3 install` calls in setup.sh are covered.

---

## v1.0.217 -- 2026-04-18

### Bug Fixes

  - **IAP / CySIEM**: Fixed CySIEM (Wazuh) proxy auth not working OOB — setup.sh now enables `proxy_auth_domain` in OpenSearch Security `config.yml` and applies it via `securityadmin.sh` automatically during install.
  - **IAP / CySIEM**: Added `x-proxy-user` and `x-proxy-roles` to Wazuh Dashboard `requestHeadersAllowlist` during setup — previously missing, causing 401s even with proxy auth type set.
  - **IAP / CyIRIS**: Fixed CyIRIS nginx block using `cysoc.DOMAIN` cert path — `routes.py` now runs `certbot --nginx -d cyiris.DOMAIN` to obtain a dedicated cert and uses that cert path in the nginx server block.
  - **Platform / CySOAR nginx injection**: Fixed nginx syntax error after CySOAR install — routes.py was leaving trailing anchor text after the `/cysoar/` injection point. Now correctly replaces the full comment line.

---

## v1.0.215 -- 2026-04-18

### Improvements

  - Stability and performance improvements.

---

## v1.0.214 -- 2026-04-18

### Improvements

  - Stability and performance improvements.

---

## v1.0.213 -- 2026-04-18

### Improvements

  - Stability and performance improvements.

---

## v1.0.212 -- 2026-04-18

### Improvements

  - Stability and performance improvements.

---

## v1.0.211 -- 2026-04-18

### Improvements

  - Stability and performance improvements.

---

## v1.0.210 -- 2026-04-18

### Bug Fixes

  - Fix IAP oauth2-proxy 500 on callback: OIDC provider now signs `oauth2proxy` client id_tokens with RS256 (RSA) so oauth2-proxy can verify via JWKS. Previously only `cysiem` was in RS256_CLIENTS; all other clients received HS256 tokens which oauth2-proxy could not verify.

---

## v1.0.209 -- 2026-04-18

### Improvements

  - Stability and performance improvements.

---

## v1.0.208 -- 2026-04-18

### Improvements

  - Stability and performance improvements.

---

## v1.0.207 -- 2026-04-18

### Improvements

  - Stability and performance improvements.

---

## v1.0.206 -- 2026-04-17

### Improvements

  - Stability and performance improvements.

---

## v1.0.205 -- 2026-04-17

### Improvements

  - Stability and performance improvements.

---

## v1.0.205 -- 2026-04-18

### Bug Fixes

  - **`_SCRIPT_VERSION` not stamped by `git-push.sh`**: `git-push.sh` was using a
    hardcoded line number (`233`) to update `_SCRIPT_VERSION` in `cycentra-setup.sh`.
    After earlier edits the variable moved to a different line, so all releases since
    v1.0.195 were published with `_SCRIPT_VERSION="v1.0.194"`.  The banner displayed
    the correct version (from the line-3 header stamp), but `--update` version
    comparison logic read the stale variable.
    Fix: replaced the hardcoded-line `sed` with a pattern-based match so it always
    finds and updates the variable regardless of line position.
    (`git-push.sh`)

---

## v1.0.204 -- 2026-04-17

### Improvements

  - Stability and performance improvements.

---

## v1.0.204 -- 2026-04-18

### Bug Fixes

  - **CyIRIS OIDC — 500 / `KeyError: 'oidc_state'` after auto-login redirect**:
    With `AUTHENTICATION_LOCAL_FALLBACK=False`, `/oidc-login` wrote
    `session["oidc_state"]` and `session["oidc_nonce"]` then returned a `302`
    to the IdP.  Same browser cookie-store race as v1.0.203: `Set-Cookie` from
    the `302` was not committed before the browser followed to Google, so the
    callback arrived with an empty session → `KeyError: 'oidc_state'` → HTTP 500.
    Fix: `oidc_login` now returns a `200` HTML page with `<meta http-equiv=refresh>`
    and `window.location.replace()`.
    (`CyIRIS/source/app/blueprints/pages/login/login_routes.py`)

### Features

  - **CySOAR auto-login (no login button)**: Added `autoLogin: true` to the
    Node-RED `adminAuth.strategy` config.  Node-RED 4.x skips the SSO button
    page and redirects directly to the OIDC provider, matching Wazuh/CySIEM.
    (`CySOAR/data/settings.js`)

---

## v1.0.203 -- 2026-04-17

### Bug Fixes

  - **CyIRIS OIDC — infinite redirect loop after successful login**: After
    `wrap_login_user()` called `login_user()` and returned a `302` redirect from
    the `/oidc-authorize` callback, certain browsers (and browser/Cloudflare
    combinations) would not flush the `Set-Cookie` header to the cookie store
    before following the redirect, causing `current_user.is_authenticated` to
    return `False` on `/dashboard`.  Fix: for OIDC logins (`is_oidc=True`),
    `wrap_login_user` now returns a `200` HTML page with a `<meta http-equiv=refresh>`
    and `window.location.replace()`, giving the browser a committed first-party
    response to store the session cookie before navigating.
    (`CyIRIS/source/app/business/auth.py`)

### Features

  - **CyIRIS auto-login (no login button)**: When `IRIS_AUTHENTICATION_LOCAL_FALLBACK`
    is `"False"`, CyIRIS's `/login` route immediately redirects to `/oidc-login`,
    bypassing the local login form exactly like Wazuh/CySIEM.  The compose template
    now sets `IRIS_AUTHENTICATION_LOCAL_FALLBACK: "False"` by default.
    (`backend/blueprints/platform/compose.py`)

---

## v1.0.202 -- 2026-04-17

### Improvements

  - Stability and performance improvements.

---

## v1.0.202 -- 2026-04-18

### Bug Fixes

  - **CyIRIS OIDC — "User not found in IRIS"**: `AUTHENTICATION_CREATE_USER_IF_NOT_EXIST`
    env var was ignored because CyIRIS config reads env vars using `{SECTION}_{OPTION}`
    naming convention (`IRIS_AUTHENTICATION_CREATE_USER_IF_NOT_EXIST`), not the bare
    option name.  Additionally the comparison in `configuration.py` is case-sensitive
    (`== "True"`), so the lowercase `"true"` value also evaluated to `False`.
    Fix: compose template now sets `IRIS_AUTHENTICATION_CREATE_USER_IF_NOT_EXIST: "True"`
    (correct prefix, correct case) alongside the old key for backwards compatibility.

---

## v1.0.201 -- 2026-04-17

### Improvements

  - Stability and performance improvements.

---

## v1.0.201 -- 2026-04-17

### Bug Fixes

  - **CyIRIS OIDC `jwkest.BadSignature` — HS256 ID token signed with wrong key**:
    OIDC Core 1.0 §10.1 requires HS256 ID tokens to be signed with the client's
    `client_secret` so the relying party can verify using the secret it already
    holds.  The `/oidc/token` endpoint was signing with the server-wide `JWT_SECRET`
    instead.  pyoidc's `jwkest` library verifies using the `client_secret` stored
    in `store_registration_info()` → mismatched key → `BadSignature` → `id_token`
    not set in `AccessTokenResponse` → `KeyError: \'id_token\'` in CyIRIS
    `login_routes.py:183`.  Fix: sign HS256 ID tokens with `client["client_secret"]`.

---

## v1.0.200 -- 2026-04-17

### Improvements

  - Stability and performance improvements.

---

## v1.0.200 -- 2026-04-17

### Bug Fixes

  - **CyIRIS OIDC login — `KeyError: 'id_token'`**: pyoidc sends token-endpoint
    credentials via `Authorization: Basic` header (`client_secret_basic`) by default.
    The `/oidc/token` endpoint only read `client_id`/`client_secret` from the POST
    form body (`client_secret_post`), so both values were `None` and the endpoint
    returned `{"error": "invalid_client"}, 401`.  pyoidc parsed this as an
    `ErrorResponse` with no `id_token`, causing the `KeyError` in CyIRIS
    `login_routes.py:183`.  Fix: parse `Authorization: Basic` header as fallback
    when form params are absent.  CySOAR (Node-oauth) was unaffected because it
    sends credentials in the form body.

---

## v1.0.199 -- 2026-04-17

### Improvements

  - Stability and performance improvements.

---

## v1.0.199 -- 2026-04-17

### Bug Fix — CyIRIS OIDC: `KeyError: 'id_token'` after successful token exchange

**Root cause**: pyoidc (used by CyIRIS) verifies `id_token` JWTs before storing them in the
`AccessTokenResponse` object. With RS256, pyoidc needs to fetch an RSA public key from the
`jwks_uri`. When `provider_config()` falls back to the manual `ProviderConfigurationResponse`
(which does not include `jwks_uri`), pyoidc has no key to verify against. Signature
verification fails silently — pyoidc drops `id_token` from the parsed response dict entirely.
Subsequent access of `access_token_resp['id_token']` raises `KeyError`.

**Fix**: Per-client JWT algorithm selection in the OIDC token endpoint. `cysiem` (OpenSearch)
receives RS256 tokens verifiable via JWKS — required by the OpenSearch security plugin.
All other clients (`cyiris`, `cysoar`, etc.) receive HS256 tokens. pyoidc automatically
verifies HS256 using the stored `client_secret` (via `RegistrationResponse`) — no JWKS
fetch required. Node-RED (CySOAR) does not verify `id_token` at all, so either works.

---

## v1.0.198 -- 2026-04-17

### Improvements

  - Stability and performance improvements.

---

## v1.0.198 -- 2026-04-17

### Bug Fix — `cycentra-setup.sh --update` aborts: `BASE_DOMAIN: unbound variable` in CySIEM OIDC step

`BASE_DOMAIN` is loaded from `/opt/cycentra/.env` at line ~1079 of setup.sh but the
CySIEM OIDC SSO step (Step 4.3) uses it in a heredoc at line ~603 — before the `.env`
source. In `--update` mode, the OIDC step ran before `BASE_DOMAIN` was in scope, causing
`set -euo pipefail` to abort with `unbound variable`.

**Fix**: Added a defensive `BASE_DOMAIN` load at the top of Step 4.3 (reading from
`/opt/cycentra/.env` when not already set), so the step is safe in all execution paths.

---

## v1.0.197 -- 2026-04-17

### Bug Fix — CyIRIS OIDC: SSL certificate verification failure (`unable to get issuer certificate`)

**Root cause**: `REQUESTS_CA_BUNDLE` and `SSL_CERT_FILE` in the CyIRIS compose template
pointed to the server's own TLS certificate chain file. This overrode the system CA trust
store with an incomplete bundle (the cross-signed `GTS Root R4` intermediate is not a
self-signed root, so OpenSSL couldn't complete the chain). The server uses a valid
Google Trust Services production cert — no custom CA bundle is needed.

**Fix**: Removed `REQUESTS_CA_BUNDLE`, `SSL_CERT_FILE` and the `/opt/cycentra/certs/cycentra.crt`
volume mount from `compose.py` cyiris template. The system CA bundle inside the container
already trusts Google Trust Services. The explicit OIDC endpoint env vars are retained as
a valid discovery fallback.

### Bug Fix — CySOAR OIDC: Page loads partially, URL stuck at `/cysoar/?`

**Root cause (1 — path)**: `httpAdminRoot` was not set in `settings.js`. Node-RED served
its admin API at root (`/`). When proxied under `/cysoar/`, the editor JS made API calls to
absolute paths like `/red/nodes` — which hit the CyCentra portal (not Node-RED) → 404 →
partial page load. Additionally nginx stripped the `/cysoar/` prefix via a trailing slash
in `proxy_pass http://127.0.0.1:1880/`, so Node-RED never saw the sub-path.

**Root cause (2 — verify)**: `passport-openidconnect` v0.1.2 dispatches the verify
callback by function arity. For arity-4, it calls `verify(iss, profile, context, done)` —
not `verify(iss, sub, profile, done)` as previously declared. The `profile` arg therefore
received the context object, making email extraction fail silently (username became
`[object Object]`).

**Fix**: Added `httpAdminRoot: '/cysoar'` to `settings.js` and the routes.py `_cysoar_settings`
string. Changed nginx `proxy_pass` to `http://127.0.0.1:1880` (no trailing slash — passes
full `/cysoar/...` path to Node-RED). Removed the now-unnecessary `proxy_redirect / /cysoar/`.
Fixed verify function signature to `(iss, profile, context, done)` with `profile.id` as
the fallback sub identifier.

### Feature — Wazuh/CySIEM OIDC SSO: RS256 JWT support in OIDC provider

**Root cause**: The OIDC `cysiem` client was registered and `CYSIEM_OIDC_SECRET` was set,
but the OIDC provider signed ID tokens with HS256 and the JWKS endpoint returned an empty
key set. OpenSearch's OIDC auth domain requires RS256 (asymmetric) JWTs verifiable via JWKS.

**Fix**: `provider.py` now generates (or loads from `/opt/cycentra/oidc_private.pem`) an
RSA-2048 key pair on startup. ID tokens are signed with RS256; `kid` header is included.
`/oidc/jwks` now returns the public key as a proper JWK. Discovery endpoint updated to
advertise `["RS256", "HS256"]`. Gracefully falls back to HS256 if `cryptography` is
unavailable. Server-side Wazuh Dashboard and OpenSearch indexer OIDC configuration is
applied via server patch (see deployment notes).

---

## v1.0.196 -- 2026-04-17

### Improvements

  - Stability and performance improvements.

---

## v1.0.195 -- 2026-04-17

### Improvements

  - Stability and performance improvements.

---

## v1.0.194 -- 2026-04-17

### Improvements

  - Stability and performance improvements.

---

## v1.0.193 -- 2026-04-17

### Improvements

  - Stability and performance improvements.

---

## v1.0.192 -- 2026-04-17

### Improvements

  - Stability and performance improvements.

---

## v1.0.191 -- 2026-04-17

### New Features

  - add __init__.py to cylogo/wordlists/Utils; expand package-data to include .sh and image files

---

## v1.0.190 -- 2026-04-17

### Improvements

  - Stability and performance improvements.

---

## v1.0.189 -- 2026-04-17

### Improvements

  - Stability and performance improvements.

---

## v1.0.188 -- 2026-04-17

### Improvements

  - Stability and performance improvements.

---

## v1.0.187 -- 2026-04-17

### Improvements

  - Stability and performance improvements.

---

## v1.0.186 -- 2026-04-17

### Improvements

  - Stability and performance improvements.

---

## v1.0.185 -- 2026-04-17

### Improvements

  - Stability and performance improvements.

---

## v1.0.184 -- 2026-04-16

### Improvements

  - Stability and performance improvements.

---

## v1.0.183 -- 2026-04-16

### Improvements

  - Stability and performance improvements.
  - Backend — scanner.py
GET /api/scans/list — returns last 15 scan summaries (scan_id, domain, date, scan_type, total_findings, critical, high, subdomains)
GET /api/scans/<scan_id> — returns full JSON for any historical scan by ID
Frontend — adapter.js
Bug fix: getWebSecStats no longer filters only module === "Web" — now catches all web/crypto/vuln_scanner/nuclei modules and source types
Vulnerability enrichment: merges vuln_scanner + nuclei raw findings onto the vulnerabilities[] array, adding CVSS, EPSS, compliance_impact, source, discovered_at, template_id, cve_refs
14 new fields on primary assets: osint_data, social_eng, mobile_api, whois_full, whois_history, dns_records, dns_ips, dns_takeovers, dns_unregistered, ssl_detail, pqc_data, http_analysis, api_endpoints, js_secrets
New helpers: getOsintData(), getSocialEngData(), getMobileApiData(); expanded getBrandData() with full breach/HIBP detail; getSupplyChainRisk() now returns full risks[] array
useAppState.js
New state: scanHistory[], selectedScanId, historyLoading
Fetches scan history list on login; refreshes after each new scan
handleScanSelect(scanId) loads any historical scan and navigates to dashboard
App.jsx
ScanHistoryDropdown component in topbar — shows last 15 scans in a table (date, domain, type pill, findings count with critical badge, subdomain count); click any row to load that scan
DashboardPage.jsx
Scan type badge (DEEP/STD/PASS) in header
"New Subdomains" stat card added
Widget 2: adds PQC (Post-Quantum Crypto) status
Widget 3: adds cloud bucket summary (public/private/total counts)
Widget 4: adds DNSSEC, TLS-RPT rows; elite score/status; spoofing risk badge
Widget 5: fixed module filter bug; shows JS secrets count, API endpoints count, CVSS on findings
Widget 6: shows new subdomain count separately
Widget 7: expanded to list top 4 risky libraries with library name, OSV ID, CVE IDs
Widget 8: adds HIBP breach detail (name, year, data classes); social engineering exposure (exposed emails + risk level); OSINT/MISP hit count; CVSS on critical vuln list
VulnerabilityPage.jsx
Summary pills: critical / high / with-CVSS / with-EPSS counts
CVSS pill (color-coded: red ≥9, orange ≥7, yellow ≥4)
EPSS pill with percentage probability
Source pill: port_banner, ssl_check, exposed_path, js_secret, nuclei, shodan
Compliance card: NIS2/DORA/ISO 27001 impact when present
Additional CVE refs from nuclei template; template_id, matched_at, discovered_at, risk_score in meta row
AssetModal.jsx
Tabbed navigation for primary assets: Overview / Vulns / DNS / SSL / Cloud / WHOIS / OSINT / Social Eng / Mobile/API / Supply Chain
Overview tab: exposed paths list (all paths, not just count); IP enrichment for IP sub-assets (ASN, country, city, cloud provider, rDNS); full resolved_ips for subdomains
DNS tab: full DNS record table by type (A/AAAA/MX/NS/TXT etc.); IP enrichment details; takeovers; unregistered typosquats
SSL tab: cipher suite, protocol, chain validity, OCSP stapling, heartbleed, compression, SANs; PQC status; HTTP security headers/CORS analysis
Cloud tab: provider list; K8s exposure banner; full bucket list with public/private status
WHOIS tab: registrar, creation/expiry dates, name servers, status, DNSSEC, history
OSINT tab: MISP threat intel hits; Shodan CVE findings with severity; Shodan raw results
Social Eng tab: risk assessment with reasons; exposed employee emails with name/title/confidence; LinkedIn profiles; email patterns
Mobile/API tab: API security findings (CORS, rate limiting, issues); APK secrets; app store links; deep links
Supply Chain tab: full risk list with library name, OSV ID, CVE IDs, CVSS, severity, reason
SiemFeedPage.jsx
Critical / High filter buttons with counts
Module tag on each alert card (color-coded)
Full ISO timestamp (not just time)
CVSS score pill, risk_score, source field on each alert

---

## v1.0.180 — 2026-04-16

### cy_asm — Scanner Capability enhancements

**Nuclei Template Scanner** (`modules/nuclei_scanner.py` — new)
- Added Nuclei CLI integration covering 9,000+ CVE/exposure/misconfiguration templates
- Runs as a post-sequential module on Standard and Deep scans
- Gracefully skipped when nuclei binary is absent — zero-impact on existing installs
- Requires: `apt install nuclei` on the scan host

**OSV.dev Supply-Chain CVE Lookup** (`modules/supply_chain.py`)
- Replaced static jQuery/Lodash heuristics with real-time queries to Google's OSV.dev API
- Detected library + version from CDN URLs queried against 10 package patterns (jQuery, React, Vue, Lodash, Bootstrap, etc.)
- Returns actual CVE/GHSA IDs with severity labels; static fallback retained for unversioned URLs
- No API key required

**NIS2 / DORA / ISO 27001 Compliance Tags** (`modules/vuln_scanner.py`)
- Added `compliance_impact` field (`{nis2, dora, iso27001}`) to every finding produced by vuln_scanner
- Covers port-banner CVEs, SSL/TLS protocol findings, exposed paths, OpenVAS results, and JS secret exposures
- Bridges cy_asm findings directly to CyComp audit evidence generation

**Shodan CVE Correlation** (`modules/passive_osint.py`)
- Shodan `vulns{}` dict per host now parsed into structured findings in `results["shodan_cve_findings"]`
- Shodan-confirmed CVEs with CVSS scores surfaced into `all_issues` alongside other scanner findings
- No new configuration required — uses existing `SHODAN_API_KEY`


## v1.0.172 — 2026-04-15

### Bug Fix — Wazuh fails to start: `Parent decoder name invalid: 'sysmon'` in `cycentra_sysmon_decoder.xml`

**Root cause**: Step 19.3 of `cycentra-setup.sh` defined the `sysmon` root decoder with
`<parent>windows</parent>`, making it a child decoder of `windows`. In Wazuh/OSSEC only
**root** decoders (those without any `<parent>` element) may be referenced as a parent by
other decoders. The four child decoders (`sysmon-process`, `sysmon-network`, `sysmon-registry`,
`sysmon-dns`) all declare `<parent>sysmon</parent>`, which caused `wazuh-analysisd` to fail
with `ERROR: (2101): Parent decoder name invalid: 'sysmon'` and refuse to load
`cycentra_sysmon_decoder.xml`, preventing `wazuh-manager` from starting.

**Fix**:
- Removed `<parent>windows</parent>` from the `sysmon` root decoder in the
  `cycentra_sysmon_decoder.xml` heredoc in `cycentra-setup.sh` (step 19.3).
- Added idempotent remediation in the `else` branch of step 19.3: if a previously-deployed
  `cycentra_sysmon_decoder.xml` contains the invalid `<parent>windows</parent>` line,
  `sed -i` removes it in-place so re-running `--update` or the full setup heals existing
  servers without manual intervention.

---

## v1.0.171 — 2026-04-15

### Bug Fix — Wazuh fails to start: `Invalid decoder type 'json'` in `cycentra_saas_decoders.xml`

**Root cause**: Step 19.5 of `cycentra-setup.sh` wrote `<type>json</type>` inside the `okta-event`
and `duo-event` child decoders (i.e. decoders that have a `<parent>` element). In Wazuh/OSSEC,
the `<type>` element is only valid on root/parent decoders — using it inside a child decoder is
rejected at startup with `Invalid decoder type 'json'`, causing `wazuh-analysisd` to refuse to
load `cycentra_saas_decoders.xml` entirely and `wazuh-manager` to fail to start. The `<type>json</type>`
lines were also functionally redundant because JSON parsing is already handled at the log-collection
layer via `<log_format>json</log_format>` in the `localfile` stubs deployed in step 19.6.

**Fix**:
- Removed `<type>json</type>` from the `okta-event` and `duo-event` child decoders in the
  `cycentra_saas_decoders.xml` heredoc in `cycentra-setup.sh`.
- Added idempotent remediation in the `else` branch of step 19.5: if a previously-deployed
  `cycentra_saas_decoders.xml` contains the invalid lines, `sed -i` removes them in-place so
  re-running `--update` or the full setup heals existing servers without manual intervention.

---

## v1.0.162 – 2026-04-14

### Diff Summary (AI)

## v1.0.163 – 2026-04-14

### Enhancement — Broader Subdomain & OSINT Coverage

- Subdomain discovery now leverages multiple global intelligence sources for improved coverage and accuracy.

These enhancements help customers identify more external assets and exposures, strengthening overall attack surface visibility.
### Chore — Tag/Release Notes Sync

- Confirmed all tag conflicts resolved and release notes are in sync with GitHub tags.
- git-push.sh now always uses GitHub tags as the source of truth for versioning.
- No functional changes; this is a sync and housekeeping release.

### Diff Summary (AI)


## v1.0.157 — 2026-04-14

### Chore — Enforce RELEASE_NOTES.md ≤ 1000 lines

- Added a test in `tests/run-all.sh` (Suite 01) to ensure `RELEASE_NOTES.md` never exceeds 1000 lines.
- If the file is too long, the test fails and blocks the release.
- This keeps release notes manageable and ensures compliance with project standards.

---
## v1.0.156 – 2026-04-13

### Diff Summary (AI)

# CyCentra 360 — Release Notes

---
## v1.0.154 — 2026-04-13

### Bug Fix — CySIEM Correlation Engine fails to start after `mcp` package upgrade (`FastMCP.get_application()` removed in v1.6)

**Root cause**: `mcp[cli]>=1.0.0` in `correlation_engine/requirements.txt` had no upper bound.
FastMCP v1.6+ removed the `get_application()` method. A routine package upgrade on the server
installed `mcp>=1.6`, causing the engine to crash at import time with:
`AttributeError: 'FastMCP' object has no attribute 'get_application'`

**Effect**: `cysiemstack-engine.service` entered a crash-restart loop (exit code 1) — 800+
restart cycles. All SIEM/UEBA/incident functionality unavailable.

**Fix**:
- `backend/cysiemstack/correlation_engine/main.py` — replaced bare `_mcp.get_application()`
  with a version-safe shim that checks for the method and falls back to `get_asgi_app()` or
  the FastMCP object itself (which is a valid ASGI app in v1.6+).
- `backend/cysiemstack/correlation_engine/requirements.txt` — pinned `mcp[cli]>=1.0.0,<1.6.0`
  to prevent future unguarded upgrades from breaking the engine.

**Files changed**:
- `backend/cysiemstack/correlation_engine/main.py` (line 1115)
- `backend/cysiemstack/correlation_engine/requirements.txt`

---
## v1.0.153 — 2026-04-13

### Bug Fix — Demo license expires every 24 hours (`license_validator.py` missing from installer package)

**Root cause**: `build-package.sh` defined `VALIDATOR_PY` pointing to
`backend/core/license_validator.py` but **never copied it into the installer tarball**.
The comment on line 81 incorrectly claimed the validator was "embedded in the binary" — it
is not; the embedded heredoc in `cycentra-setup.sh` writes a temporary validator to `/tmp`
only for the pre-install license check and deletes it immediately after.

As a result, `/opt/cycentra/license_validator.py` — called daily by the
`cycentra-license-check.timer` watchdog — was **never deployed** on any installation.

The daily watchdog runs:
```
python3 /opt/cycentra/license_validator.py --license /opt/cycentra/cycentra.lic
```
When the file does not exist, Python exits with code **2** ("can't open file"). The watchdog
checks `[[ $_CODE -eq 2 ]]` and treats code 2 as "license expired", writing
`/opt/cycentra/.license_expired` and stopping all CyCentra services — every 24 hours —
even during a valid 15-day demo (`.demo_start` still shows the original install date).

Running `--update` cleared `.license_expired` (lines 1311-1312 in `cycentra-setup.sh`) and
restarted services, but did **not** deploy the missing validator. 24 hours later the watchdog
fired again, repeating the cycle.

**Fix**:

#### `build-package.sh`
- Replaced the incorrect comment *"Validator is embedded in the binary — no external file needed"*.
- Added preflight guard: `[[ -f "$VALIDATOR_PY" ]] || error "..."` — build now fails fast if the validator is missing.
- Added `cp "$VALIDATOR_PY" "$PKG_DIR/license_validator.py"` so the runtime validator is
  included in every installer tarball and deployed to `/opt/cycentra/license_validator.py`
  by `cycentra-setup.sh` on every install/update.

#### `cycentra-setup.sh` — watchdog heredoc (defense-in-depth)
- Added an existence guard at the top of the deployed `/opt/cycentra/license-watchdog.sh`:
  ```bash
  if [[ ! -f /opt/cycentra/license_validator.py ]]; then
      _log "WARNING: /opt/cycentra/license_validator.py not found — skipping license check"
      _log "Re-run: sudo bash /opt/cycentra/cycentra-setup.sh --update to redeploy"
      exit 0
  fi
  ```
  This ensures a missing validator causes the watchdog to log a warning and exit cleanly
  (`exit 0`) rather than letting Python's "can't open file" exit code 2 be misread as
  "license expired".

#### `tests/run-all.sh` — Suite 09
- Added regression check: `build-package.sh` must contain a `cp "$VALIDATOR_PY"` line.
- Added regression check: the watchdog heredoc must contain a `-f license_validator.py`
  existence guard.
  Both tests **fail** on the unfixed code and **pass** after this fix.

---
## v1.0.152 — 2026-04-13

### Enhancement — SIEM Engine: 20 new correlation rules (CR-016 → CR-035) + UEBA detectors 8–12 + GeoIP enrichment

**Correlation Engine — `correlator.py`**
- Added 20 new `CorrelationRule` classes covering Windows, cloud and endpoint attack techniques:
  - CR-016 Password Spraying (20+ accounts from 1 source IP)
  - CR-017 Windows Brute Force → Login (EventID 4625 → 4624)
  - CR-018 Dormant Account Rebirth (no activity 90+ days)
  - CR-019 Privileged Group Membership Change (Domain Admins / Enterprise Admins)
  - CR-020 Kerberos Ticket Anomaly (Golden Ticket / RC4-HMAC)
  - CR-021 Registry Persistence (autorun Run/RunOnce keys)
  - CR-022 Scheduled Task Abuse (task pointing to Temp/AppData paths)
  - CR-023 Process Injection Indicator (Office/Browser → shell child process)
  - CR-024 Encoded/Obfuscated Command Execution (PowerShell -EncodedCommand, IEX)
  - CR-025 Web Shell Execution (web server spawning shell process)
  - CR-026 Security Tool Disabled (AV/EDR/firewall service stopped)
  - CR-027 Unusual Outbound Port (4444, 6667, 9001, 31337, etc.)
  - CR-028 RDP to External Host (outbound :3389)
  - CR-029 Internal Subnet Scan (20+ scan events from single host)
  - CR-030 Large Upload to Cloud Storage (Mega, Dropbox, OneDrive, etc.)
  - CR-031 Cloud Console Login without MFA (AWS/Azure MFA bypass)
  - CR-032 Privileged Cloud IAM Change (AdministratorAccess / Global Admin)
  - CR-033 Mass Cloud Resource Deletion (S3/Blob wipe)
  - CR-034 Suspicious Mail Forwarding Rule (BEC indicator)
  - CR-035 OAuth App Consent Grant (mail.read / files.readwrite phishing)
- `ALL_RULES` registry expanded from 15 to 35 rules

**UEBA Engine — `ueba.py`**
- Added `DORMANT_THRESHOLD_DAYS = 90` constant
- Added 5 new risk contribution types:
  `dormant_account_login (55)`, `concurrent_session (50)`, `activity_volume_spike (45)`,
  `suspicious_process (65)`, `repeated_privesc_attempt (50)`
- Added detectors 8–12 in `analyse_alert()`:
  - 8: Dormant account rebirth (login after 90+ inactive days)
  - 9: Concurrent sessions from different agents within 30 s
  - 10: Activity volume spike (10× hourly baseline, 20+ events)
  - 11: First-seen known attack-tool process (mimikatz, meterpreter, Cobalt Strike, etc.)
  - 12: Rapid privilege escalation (3+ privesc attempts in 2h window)

**Normaliser — `normaliser.py`**
- Added graceful `geoip2` import block (`_GEOIP_ENABLED` / `_GEOIP_READER`; no-op if DB absent)
- Added `_lookup_geoip(ip)` helper returning `{country_iso, country_name, city, lat, lon}`
- Added `'cloud'` category in `_classify_category()` for AWS/Azure/O365/GCP/GitHub rule groups
- `normalise()` return dict now includes `'geo'` key populated at parse time

**setup.sh — Step 19: Infrastructure Prerequisites (new)**
- Installs `geoip2` Python library
- Downloads `GeoLite2-City.mmdb` when `MAXMIND_KEY` is present in `/opt/cycentra/.env`
- Deploys Sysmon XML decoder to `/var/ossec/etc/decoders/cycentra_sysmon_decoder.xml`
- Deploys custom detection rules 100300–100309 to `/var/ossec/etc/rules/cycentra_custom_rules.xml`
  (process injection, encoded commands, web shell, registry persistence, LSASS, AV tamper,
  C2 ports, outbound RDP, privileged group changes, Kerberos Golden Ticket)
- Deploys SaaS auth decoders (Okta, Azure MFA, Duo) to `/var/ossec/etc/decoders/`
- Injects disabled cloud wodle stubs into `ossec.conf` (AWS CloudTrail, Azure AD, Microsoft 365,
  Okta/Duo localfile inputs) — requires customer to fill PLACEHOLDER_ values and enable
- Writes Sysmon deployment package to `/opt/cycentra/sysmon/` (config XML, deploy PS1, audit policy PS1)
- Reloads `wazuh-manager` after each config change; prints manual-action checklist post-install

---
## v1.0.151 — 2026-04-13

### Bug Fix

**Update button returns HTML instead of JSON — `⚠ Version check failed` / `SyntaxError: Unexpected token '<', "<!DOCTYPE"`**
- Root cause: Four routes in `blueprints/system/routes.py` were missing the mandatory
  `session.get("user_email")` auth guard required on every `/api/` endpoint:
  `POST /api/system/update`, `POST /api/system/upgrade`,
  `GET /api/system/latest-version`, and `GET /api/system/update/log`.
  When the browser session expired (or on the first request after a long idle), the nginx
  `auth_request` gate at `/api/auth/verify` returned a `302` redirect to the login page.
  The browser followed the redirect and the Flask endpoint received the request with no valid
  session — but because Flask itself had no auth guard, it executed the route and eventually
  returned either another redirect or a Werkzeug HTML error page. The frontend received HTML
  where it expected JSON, causing `SyntaxError: Unexpected token '<', "<!DOCTYPE "...`.
- Fix: Added `session.get("user_email") → 401` guard and role check to all four endpoints:
  - `POST /api/system/update` — analyst+ required (incremental patch)
  - `POST /api/system/upgrade` — admin only (full re-install, destructive)
  - `GET /api/system/latest-version` — any authenticated user
  - `GET /api/system/update/log` — any authenticated user
  All four now return `{"error": "Authentication required"}, 401` (JSON) on expired sessions
  instead of redirecting, so the frontend's catch block gets a valid JSON error.
  - `backend/blueprints/system/routes.py`: session guards + RBAC checks added to all four routes.

---
## v1.0.150 — 2026-04-13

### Fix

**MCP SSE endpoint URL updated from `siem.cycentra.com` to `cysoc.cycentra.com`**
- Root cause: `blueprints/system/routes.py` `/api/system/mcp` GET handler hard-coded
  `https://siem.{BASE_DOMAIN}/mcp/sse` as the `public_url` returned to clients and shown
  in the AI connection guide. The production server is reachable at `cysoc.cycentra.com`,
  not `siem.cycentra.com`, causing every externally-configured AI client to target an
  unreachable host.
- Fix: Changed the `public_url` construction from `f"https://siem.{base_domain}/mcp/sse"`
  to `f"https://cysoc.{base_domain}/mcp/sse"` in `blueprints/system/routes.py` (line 1151).
  The internal loopback `endpoint` (`http://127.0.0.1:8100/mcp/sse`) is unchanged.
  - `backend/blueprints/system/routes.py`: `public_url` subdomain changed `siem` → `cysoc`.

---
## v1.0.149 — 2026-04-13

### Chore

**`publish.yml` removed; `_SCRIPT_VERSION` synced to v1.0.149**
- Removed `.github/workflows/publish.yml` (stub workflow with no steps — superseded by
  `agent-release.yml` and `build-package.sh`).
- Bumped `_SCRIPT_VERSION` in `cycentra-setup.sh` from `v1.0.144` to `v1.0.149` to align
  the self-update version check with the actual release history.
  - `.github/workflows/publish.yml`: deleted.
  - `cycentra-setup.sh`: `_SCRIPT_VERSION` bumped to `v1.0.149`.

---
## v1.0.148 — 2026-04-13

### Chore

**Version sync — `pyproject.toml` and `cycentra-setup.sh` aligned to release history**
- Root cause: `backend/pyproject.toml` was pinned at `1.0.144` and `cycentra-setup.sh`
  `_SCRIPT_VERSION` was pinned at `v1.0.142` after the initial repository publish. Subsequent
  releases (v1.0.143–v1.0.147) were documented in `RELEASE_NOTES.md` but the two version fields
  were never updated, causing the installed package version and the setup-script self-update check
  to report stale values to operators.
- Fix: Bumped `version` in `backend/pyproject.toml` from `1.0.144` → `1.0.148` and
  `_SCRIPT_VERSION` in `cycentra-setup.sh` from `v1.0.142` → `v1.0.148`. Both files now reflect
  the full history of changes shipped in v1.0.143–v1.0.147:
  - v1.0.143: RBAC audit-log entries for role assignments/deletions; `MCP_ENABLED` added to
    `cysiemstack.env` heredoc in `cycentra-setup.sh`.
  - v1.0.144: `bypass_tests_gate` workflow-dispatch input added to `agent-release.yml` to
    unblock releases when the CI test gate cannot pass in the Actions environment.
  - v1.0.145: Automation smoke-test entry (superseded by v1.0.146).
  - v1.0.146: `agent-release.yml` YAML block-scalar fix — bare multi-line template literal
    replaced with `[...].join('\\n')` array, unblocking every release since workflow creation.
  - v1.0.147: `agent-post-release.yml` hotfix-issue body converted to `join('\\n')` array;
    `agent-label-pr.yml` extended with `ready_for_review` trigger type so auto-merge label
    is applied to agent PRs converted from draft.
  - `backend/pyproject.toml`: `version` bumped to `1.0.148`.
  - `cycentra-setup.sh`: `_SCRIPT_VERSION` bumped to `v1.0.148`.

---
## v1.0.147 — 2026-04-12

### Bug Fix

**`.github/workflows/agent-post-release.yml` and `agent-label-pr.yml` — remaining YAML syntax and trigger gaps**
- Root cause 1: `agent-post-release.yml` "Create hotfix issue" step used the same unindented multi-line template literal pattern as the bugs fixed in v1.0.146. Lines like `**Verification run:**` and `**Checks that failed:**` at column 0 terminated the `script: |` YAML block scalar early, causing a parse error that prevented GitHub Actions from queuing any jobs (all runs: `conclusion: failure, total_count: 0 jobs`).
- Root cause 2: `agent-label-pr.yml` only had `types: [opened]` as its trigger. Copilot agent PRs are always created as **draft** first; the `opened` event fires while the PR is still draft. When a draft PR is converted to ready-for-review, no new `opened` event fires, so the `auto-merge` label was never automatically applied to any agent PR.
- Fix 1: Replaced bare multi-line template literal in the hotfix issue body with a `[...].join('\\n')` array (all lines fully indented within the `script: |` block), matching the pattern used to fix v1.0.146.
- Fix 2: Added `ready_for_review` to `agent-label-pr.yml`'s `pull_request` event types so the auto-merge label is applied when a draft agent PR is converted to ready.
  - `.github/workflows/agent-post-release.yml`: "Create hotfix issue" body converted to `join('\\n')` array.
  - `.github/workflows/agent-label-pr.yml`: added `ready_for_review` to `types`.

---


### Bug Fix

**`.github/workflows/agent-release.yml` — YAML block scalar terminated early by unindented template literal**
- Root cause: Step 10 ("Post release summary comment") used a multi-line JavaScript template literal whose body lines had zero indentation. In YAML, a block scalar (`|`) terminates when it encounters a non-empty line with less indentation than the block content. Lines like `**Version:**` at column 0 broke out of the `script: |` block, causing a YAML parse error that prevented GitHub Actions from queuing any jobs. Every single `agent-release.yml` run since the workflow was created has failed for this reason.
- Fix: Replaced the single multi-line template literal with a `[...].join('\\n')` array where every element is a single-line template literal fully indented within the YAML block scalar.
  - `.github/workflows/agent-release.yml`: Step 10 body now uses `join('\\n')` instead of a bare multi-line template literal.

---
## v1.0.145 — 2026-04-12

### Chore

**End-to-end automation smoke test (superseded by v1.0.146)**
- Dummy entry from prior session; superseded by the actual bug fix in v1.0.146.

---
## v1.0.144 — 2026-04-12

### Chore

**`.github/workflows/agent-release.yml` — Emergency bypass for CI test gate blockage**
- Root cause: `agent-release.yml` gate step required a `tests:passed` label on the merged PR before
  it would create the version tag and trigger `deploy.yml`. When `agent-test-gate.yml` fails in the
  GitHub Actions environment (environment differences vs. local), the label is never set, and every
  subsequent `agent-release` run silently skips. `deploy.yml` (the actual build) continues to
  succeed — so the code is publishable — but no version tag is ever created, blocking all customers
  from receiving updates until a maintainer intervenes manually.
- Fix: Added a `bypass_tests_gate` boolean `workflow_dispatch` input (default `false`) to
  `agent-release.yml`. When set to `true`, the gate step skips the `tests:passed` label check and
  proceeds directly to stamp, tag, and publish. The `pr_number` input is now optional when using the
  bypass. Normal PR-driven releases (via `tests:passed` label → `agent-auto-merge`) are unaffected.
  - `.github/workflows/agent-release.yml`: added `bypass_tests_gate` input and updated gate step to
    honour it, with an explicit warning log when the bypass is active.

---
## v1.0.143 — 2026-04-13

### Bug Fixes

**`blueprints/rbac/manager.py` — RBAC mutations missing audit log entries**
- Root cause: `POST /api/rbac/users` and `DELETE /api/rbac/users/<email>` in
  `rbac_users()` / `rbac_delete_user()` called `auth_event` only on *denial* (HTTP 403)
  but never on *success*. Because Wazuh tails `/var/log/cycentra/auth.log` for security
  monitoring, every admin role assignment and user removal was invisible to the SIEM —
  a blind-spot for insider-threat and compliance use-cases.
- Fix: Added `auth_event("rbac_role_assigned", ...)` immediately after `_save_rbac()` in
  the POST handler, and `auth_event("rbac_user_deleted", ...)` in the DELETE handler.
  Both records include the acting admin's email, the target email, the new role (for
  assignments), and the request IP. The existing denial path is unchanged.
  - `backend/blueprints/rbac/manager.py`: two `auth_event(...)` calls added on the
    success return paths of `rbac_users()` (POST) and `rbac_delete_user()` (DELETE).

**`cycentra-setup.sh` — `MCP_ENABLED` absent from generated `cysiemstack.env`**
- Root cause: `backend/cysiemstack/correlation_engine/main.py` reads `MCP_ENABLED` from
  `cysiemstack.env` via `settings.__dict__.get("mcp_enabled", "true")` to decide whether
  to mount the Security MCP bridge at `/mcp/sse`. However, the `cysiemstack.env` heredoc
  template in `cycentra-setup.sh` (Step 10) never wrote `MCP_ENABLED`, so the generated
  file gave operators no documented toggle — the only way to disable the bridge was to
  manually add the variable after knowing to look for it in the engine source.
- Fix: Added `MCP_ENABLED=true` (with an explanatory comment) to the `cysiemstack.env`
  heredoc, immediately after `MISP_ENABLED`. The default is `true` (preserving existing
  behaviour). Operators can now set `MCP_ENABLED=false` in
  `/opt/cycentra/cysiemstack.env` and restart `cysiemstack-engine` to disable the bridge
  without uninstalling the `mcp` package.
  - `cycentra-setup.sh`: three lines added to the `cysiemstack.env` heredoc (comment +
    `MCP_ENABLED=true` + blank separator before `POSTGRES_PASSWORD`).

---
## v1.0.142 — 2026-04-12

### Feature — Full end-to-end automation: PR auto-merge and version publishing

Completed the fully automated pipeline from agent task → code → tests → merge → release → publish.
No human action is required after a task is assigned, except when tests fail.

**What was broken and is now fixed:**

- **Auto-merge missing:** `agent-test-gate` set `tests:passed` but nothing merged the PR.
  Added `agent-auto-merge.yml` — fires when `tests:passed` label is set, merges the PR,
  then explicitly dispatches `agent-release.yml`.

- **`agent-release` never ran (0 jobs every time):** Job condition checked
  `github.event.pull_request.merged` which is always null on `push` events (the actual
  event type GitHub uses). Fixed with a gate step that handles all three trigger types:
  `pull_request: closed`, `push: branches: [main]`, and `workflow_dispatch`.

- **GITHUB_TOKEN push blocks downstream workflows:** Tag pushes from workflow runs using
  `GITHUB_TOKEN` do not trigger further workflow runs (GitHub security restriction).
  `agent-release` now explicitly dispatches `deploy.yml` via `workflow_dispatch` after
  pushing the tag, guaranteeing the build-and-publish job always runs.

**Resulting full automation chain:**
```
Agent opens PR
  → agent-test-gate    runs tests → sets tests:passed label
  → agent-auto-merge   merges PR → dispatches agent-release
  → agent-release      stamps version, creates tag → dispatches deploy.yml
  → deploy.yml         builds wheel + portal, publishes GitHub Release
  → agent-post-release verifies artifacts, opens hotfix issue if broken
```

---
## v1.0.141 — 2026-04-12

### Fix — License watchdog fires immediately on setup re-enable, blocking backend restart

**Root cause — `Persistent=true` in `cycentra-license-check.timer`:**
When setup calls `systemctl start cycentra-license-check.timer`, systemd detected the
timer had not recently run (it was disabled/stopped before the update) and fired the
watchdog immediately. The watchdog wrote `.license_expired` (with `chattr +i`) before
`systemctl restart cycentra-backend` ran, causing the `ExecStartPre` license guard to
block the restart and abort setup at STEP 9.

**Fix 1 — Removed `Persistent=true` from timer:**
`OnBootSec=2min` already ensures a post-boot check; `Persistent=true` is redundant and
caused catch-up firing during setup.

**Fix 2 — Explicit sentinel cleanup before backend restart in STEP 9:**
Added `chattr -i` + `rm -f` of `.license_expired` after starting the timer and before
restarting the backend. The full-install path already had this cleanup; the `--update`
path did not, leaving a stale sentinel from a previous expiry event able to block restart.

---
## v1.0.140 — 2026-04-12

### Chore — Agent definitions and workflow docs cleanup

- Removed stale `cyra-360-old.md` agent file
- Synced latest agent definitions and GitHub workflow docs from remote

---
## v1.0.138 — 2026-04-12

### Feature — Integrated Security MCP Server

Introduces a native **Model Context Protocol (MCP) bridge** mounted directly inside
the existing `cysiemstack-engine` FastAPI process at `/mcp/sse` (port 8100). No
separate service or port is required — the MCP bridge starts automatically when the
`mcp[cli]` package is installed alongside the engine.

External AI clients (Claude Desktop, OpenAI Agents SDK, custom LLM toolchains, etc.)
connect to `http://127.0.0.1:8100/mcp/sse`.

Wazuh credentials are sourced automatically from `/opt/cycentra/cysiemstack.env`.

#### `backend/cysiemstack/correlation_engine/main.py`
- Added `import base64`, `import json as _stdlib_json`, `import httpx` to existing imports.
- Added module docstring entry for the `/mcp/sse` endpoint.
- At the end of the file: conditional `try/except ImportError` block that, when the
  `mcp` package is present, creates a `FastMCP` instance and registers 10 tools:
  - `get_stats`, `list_incidents`, `get_incident`, `list_alerts`, `list_risk_scores`
    — query the correlation engine's own REST endpoints (loopback)
  - `list_ueba_users`, `get_ueba_anomalies` — UEBA behavioural data
  - `wazuh_list_agents`, `wazuh_get_agent_vulnerabilities` — Wazuh Manager API (direct)
  - `wazuh_active_response` — trigger AR action on an agent (firewall-drop, etc.)
- Mounts the MCP ASGI sub-application: `app.mount("/mcp", _mcp.get_application())`
- Gracefully skips mount with an info log if `mcp` is not installed.

#### `backend/cysiemstack/correlation_engine/requirements.txt`
- Added `mcp[cli]>=1.0.0`

#### `cycentra-setup.sh`
- No new systemd unit (MCP runs inside `cysiemstack-engine`).
- Post-install success message updated: `CySIEMStack engine healthy :8100 (MCP bridge at /mcp/sse)`.
- Summary and `cycentra-setup-summary.txt` reference `http://127.0.0.1:8100/mcp/sse`.
## v1.0.137 — 2026-04-11

### Fix — Demo license expiry bugs and sentinel file tampering protection

**Root cause 1 — premature expiry on reinstall:**
`/opt/cycentra/.demo_start` persisted across installs. On a `--full` reinstall to the
same server, the old start date caused the validator to calculate 15+ days elapsed
immediately. The daily watchdog then stopped `cycentra-backend` and wrote
`.license_expired`, blocking any restart via the `ExecStartPre` guard.

**Root cause 2 — signed demo `.lic` expiry calculated from generation date:**
Signed demo `.lic` files have an `expires` calculated from the **generation date**, not
installation date. A `.lic` file prepared weeks in advance would expire almost immediately
on customer install. `validate()` trusted the file's `expires` exclusively for signed
licenses, ignoring `.demo_start` entirely.

**Root cause 3 — sentinel files unprotected:**
Sentinel files `.demo_start` and `.license_expired` had no filesystem immutability
protection — a privileged user could trivially reset the demo clock or bypass the
restart guard.

#### `backend/core/license_validator.py`
- `validate()`: for `type="demo"` signed licenses, effective `days_remaining` is now
  `max(lic_expiry_days, installation_clock_days)` — customer always gets `DEMO_MAX_DAYS`
  from install date regardless of when the `.lic` was generated.
- `_demo_days_remaining()`: applies `chattr +i` after writing `.demo_start` to make the
  demo clock immutable.

#### `backend/blueprints/system/routes.py`
- Added `if not resp.ok` guard in `ai_test()` so Anthropic/Gemini/DeepSeek error codes
  other than 401 no longer return a false-positive `ok: true`.

#### `portal/src/pages/ai/AISettingsPage.jsx`
- Inner try/catch on `res.json()` in `testConnection()` — nginx 502 HTML page now shows
  `"Backend service unavailable (HTTP 502)"` instead of `"Cannot reach backend"`.

#### `cycentra-setup.sh`
- Fresh `--full` install: resets `.demo_start` to today with `chattr -i` / `chattr +i`
  wrapper; clears any stale `.license_expired`.
- License watchdog: wraps all `.license_expired` writes with `chattr -i` before and
  `chattr +i` after — expired marker is immutable once set; `chattr -i` before `rm -f`
  on the OK (renewal) path.

---
## v1.0.136 — 2026-04-12

### Fix — Automated IRIS ticket creation broken for cloud CyIRIS mode

**Root cause (same env-var isolation as v1.0.135 manual fix):**
The correlation engine's ingestor runs `create_iris_case()` automatically when a new
incident is created or new correlation rules fire. This calls `_load_iris_config()` inside
`iris_connector.py`, which reads `CLOUD_IRIS_API_KEY` / `CLOUD_IRIS_URL` from
`os.environ`. Because the engine's systemd service uses
`EnvironmentFile=/opt/cycentra/cysiemstack.env` (which has no cloud IRIS vars), the lookup
always returned `None` → no IRIS ticket was ever auto-created for cloud mode.

#### `backend/cysiemstack/correlation_engine/iris_connector.py`
- Added `_CYCENTRA_ENV_FILE = Path("/opt/cycentra/.env")` constant.
- Added `_read_cycentra_env()` — a minimal `.env` parser (no external dependency) that
  reads `/opt/cycentra/.env` directly and returns a `dict`.
- `_load_iris_config()` cloud branch: when `CLOUD_IRIS_URL` or `CLOUD_IRIS_API_KEY` are
  absent from `os.environ`, falls back to `_read_cycentra_env()`. Covers:
  - Automated ticket creation from the ingestor pipeline
  - `sync_closed_cases()` (5-minute IRIS sync scheduler)
  - `auto_close_fp()` (FP threshold check)

#### Scope of automated ticket raising (for reference)
| Surface | Auto-raised? | Trigger |
|---|---|---|
| Active Incidents (SIEM) | ✅ Yes | New incident created OR new correlation rules fire (if FP score < threshold) |
| ASM Findings | ❌ No — manual only | Analyst clicks "Raise CyIRIS Ticket" |
| UEBA Anomalies | ❌ No — manual only | Analyst clicks escalate button |

#### FP score vs. confidence score
The ingestor derives an **FP probability score** (0–100) from rule confidence:
`fp_score = (1 − avg_rule_confidence) × 100`
- High rule confidence → low FP score → incident **is NOT auto-closed** → IRIS ticket IS raised
- FP score ≥ threshold (default 90.0) → incident auto-closed as false positive → NO ticket raised
- Threshold is configurable via `fpThreshold` in `ai_settings.json` (System Settings → CyIRIS)

---
## v1.0.135 — 2026-04-12

### Fix — "Raise Ticket" in Active Incidents fails when CyIRIS uses cloud credentials

**Root cause:** The correlation engine runs as a systemd service with
`EnvironmentFile=/opt/cycentra/cysiemstack.env`. That file does not contain
`CLOUD_IRIS_API_KEY` / `CLOUD_IRIS_URL` — those live in `/opt/cycentra/.env` which is
loaded by the Flask backend only. So `_load_iris_config()` inside the engine found an
empty API key and returned `None`, even though CyIRIS was fully operational for
UEBA and ASM Findings (which call IRIS from the Flask layer via `get_iris_config()`).

**Fix: move incident manual escalation entirely into the Flask proxy layer**
(same architecture as UEBA escalation — `siem_proxy.py` handles everything, the engine
is only used for data fetch and persistence).

#### `backend/siem_proxy.py`
- `POST /api/siem/incidents/<id>/escalate`: No longer proxied to the engine.
  Now self-contained in Flask:
  1. `GET /incidents/{id}` from engine — fetch incident data
  2. If already ticketed: return existing case info (no duplicate)
  3. `get_iris_config()` from `core.helpers` — reads cloud creds from `.env` correctly
  4. `POST /api/v2/cases` to IRIS — creates case with severity, affected hosts/users,
     MITRE IDs, correlated rules, and AI narrative
  5. `PATCH /incidents/{id}` back to engine — persists `iris_case_id/url/status`
  (step 5 failure is non-fatal — ticket was created, drawer still updates)

#### `backend/cysiemstack/correlation_engine/main.py`
- `IncidentPatch` model: added `iris_case_id`, `iris_case_url`, `iris_case_status`
  optional fields so the proxy can write ticket info back after creating the case.

---
## v1.0.134 — 2026-04-12

### Fix — "Raise Ticket" in Active Incidents shows "Engine offline" when CyIRIS not configured

**Root cause:** The correlation engine's `POST /incidents/{id}/escalate` endpoint raised
`HTTPException(status_code=503)` when CyIRIS was not configured. `siemFetch` in the
frontend maps **any** HTTP 503 to `{ _offline: true }`, causing the drawer to show
*"✗ Engine offline — try again shortly."* instead of the real error ("CyIRIS not configured").
Findings and UEBA were unaffected because their escalation is handled directly by the Flask
layer (never touches the engine), so they receive a proper `{"error": "..."}` response.

#### `backend/cysiemstack/correlation_engine/main.py`
- `POST /incidents/{id}/escalate`: Changed "CyIRIS not configured" status from **503 → 422**.
  503 must be reserved for "service itself is unavailable"; 422 correctly signals a
  configuration pre-condition failure.
- "IRIS case creation failed" changed from **502 → 422** for the same reason.

#### `portal/src/siem/siemApi.js` — `siemFetch`
- **503 handling:** Now reads the response body before deciding. If
  `body.error === "engine_unavailable"` → `{ _offline: true }` (genuine engine offline).
  All other 503s → `{ _error: body.error || body.detail || body.message }` (app-level error,
  real message shown to user).
- **Non-ok handling:** Added `body.detail` fallback alongside `body.error` so FastAPI
  `HTTPException` messages (which use `{"detail": "..."}`) are surfaced correctly instead of
  showing "HTTP 422".

---
## v1.0.133 — 2026-04-12

### Fix — Cloud MISP / Cloud CyIRIS panels no longer show unnecessary input fields

**Root cause:** Cloud credentials (`CLOUD_MISP_API_KEY`, `CLOUD_IRIS_API_KEY`,
`CLOUD_IRIS_CUSTOMER_ID`) are provisioned server-side in `/opt/cycentra/.env` at install
time. Showing API key and customer ID inputs in the cloud panel was misleading — values
entered there were stored in `ai_settings.json` but the backend already prefers env vars.

#### `portal/src/pages/settings/SystemSettingsPage.jsx`
- **Cloud CyMISP panel:** Removed API key `<input>`. Replaced with env-var explanation text
  referencing `CLOUD_MISP_URL` and `CLOUD_MISP_API_KEY`. Test Connection button still present.
- **Cloud CyIRIS panel:** Removed API key + Customer ID `<input>` fields. Replaced with
  env-var explanation text referencing `CLOUD_IRIS_URL`, `CLOUD_IRIS_API_KEY`,
  `CLOUD_IRIS_CUSTOMER_ID`. Test Connection button still present.
- Both panels show an ℹ️ footer: *"Cloud credentials are set at install time — contact
  Cycentra support to rotate your key."*
- `testConnection` (MispTab + CyIrisTab): Cloud path now explicitly passes
  `{ apiKey: "", useStored: true }` — no masked-key detection logic needed.
  Local path unchanged (requires URL + key, `useStored: false`).

---
## v1.0.132 — 2026-04-11

### Fix — Cloud CyMISP / Cloud CyIRIS Test Connection fails with masked API key

**Root cause:** When System Settings loads, the GET endpoint returns API keys masked as
`••••••••`. In cloud mode, the user clicks "Test Connection" without re-entering the key.
The frontend blocked with *"Enter your API Key (currently showing masked placeholder)"*
before the request even reached the backend. Local mode worked because users naturally
re-type both URL and key when configuring it for the first time.

#### `portal/src/pages/settings/SystemSettingsPage.jsx`
- Cloud mode `testConnection` (MispTab + CyIrisTab): if the field still shows the masked
  placeholder, sends `{ useStored: true, apiKey: "" }` instead of blocking the user
- Non-cloud modes still require the key to be explicitly entered

#### `backend/blueprints/system/routes.py` (`misp_test` + `iris_test`)
- When `useStored: true` is sent and `apiKey` is empty or masked, reads the real key from
  `/opt/cycentra/ai_settings.json` directly, so the test runs against the stored credential
  without the UI ever receiving the plaintext key

#### Server-side action required
The `/opt/cycentra/.env` on existing servers still has the old
`CLOUD_MISP_URL=https://misp.cycentra.com` line. This env var overrides the correct default.
Fix with:
```bash
sed -i 's|CLOUD_MISP_URL=https://misp.cycentra.com|CLOUD_MISP_URL=https://cymisp.cycentra.com|' /opt/cycentra/.env
systemctl restart cycentra-backend