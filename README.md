# IAM Portfolio Labs

Hands-on identity and access management labs built on a RHEL 10 environment modeled on GovTech network segmentation and STIG hardening.

## Environment
- **Gov-Admin**: Ansible controller, Splunk SIEM
- **Gov-Auth**: FreeIPA identity provider, HashiCorp Vault
- **Gov-App** (192.168.56.30): application server, SSH gated by Vault one-time passwords
- **Cloud**: Microsoft Entra ID (P2) for governance labs

## Labs
| Lab | Focus | Status |
|---|---|---|
| 1. [JML Automation](jml-lab/) | Joiner-Mover-Leaver lifecycle in Ansible against FreeIPA, least-privilege service account | Complete |
| 2. [Identity Governance](iga-lab/) | Entra ID access packages, access reviews, Conditional Access; midPoint reconciliation with FreeIPA | Complete |
| 3. [Privileged Access](pam-lab/) | HashiCorp Vault secrets, least-privilege policies, just-in-time SSH with one-time passwords | In progress |

The labs connect: the JML Leaver playbook disables the user in FreeIPA, removes group memberships, and revokes any outstanding Vault SSH leases, so offboarding closes both the identity and the privileged access path.

## Highlight: a real bug, found and fixed
While building the mover playbook, the community.general `ipa_group` module with `state: absent` deleted the entire group instead of removing one member. I reproduced it, isolated the cause, and rewrote the mover and leaver playbooks to call the `ipa` CLI directly under a Kerberos-authenticated session. See [jml-lab/TROUBLESHOOTING.md](jml-lab/TROUBLESHOOTING.md).

## Documentation approach
Each lab includes design notes, screenshots, and broken-versus-fixed state logs. Where a lab takes a shortcut I wouldn't take in production, the notes say so.
