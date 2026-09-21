# IAM Portfolio Labs

Hands-on identity and access management labs built on a three-node RHEL 10 environment modeled on GovTech network segmentation and STIG hardening.

## Environment
- **Gov-Admin**: Ansible controller, Splunk SIEM
- **Gov-Auth**: FreeIPA identity provider
- **Cloud**: Microsoft Entra ID (P2) for governance labs

## Labs
| Lab | Focus | Status |
|---|---|---|
| 1. [JML Automation](jml-lab/) | Joiner-Mover-Leaver lifecycle in Ansible against FreeIPA, least-privilege service account | Complete |
| 2. [Identity Governance](iga-lab/) | Entra ID access packages, entitlement management, expiration policies | Complete |
| 3. Privileged Access | HashiCorp Vault and FreeIPA | In progress |

## Highlight: a real bug, found and fixed
While building the leaver playbook, the community.general `ipa_group` module with `state: absent` deleted the entire group instead of removing one member. I reproduced it, isolated the cause, and rewrote the mover and leaver playbooks to call the `ipa` CLI directly under a Kerberos-authenticated session. See [jml-lab/TROUBLESHOOTING.md](jml-lab/TROUBLESHOOTING.md).

## Documentation approach
Each lab includes design notes, screenshots, and broken-versus-fixed state logs.
