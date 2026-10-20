# Lab 2: Identity Governance (Entra ID + midPoint)

Covers the governance side of IAM in two environments: Microsoft Entra ID (P2) in the cloud, and midPoint, an open-source IGA platform, on-prem against the same FreeIPA directory the JML lab provisions into. Lab users and groups carry a `Lab-` / `SG-LAB-` prefix because the tenant is a real one.

## Entra ID

| Post | What it proves |
|---|---|
| [Post 7: Tenant + identity fundamentals](post7-entra-tenant/) | Test users and an assigned-membership security group that the rest of the lab governs |
| [Post 8: Access package](post8-access-package/) | Access requested through a catalog, approved by a designated approver, and expiring after 30 days |
| [Post 9: Access review](post9-access-review/) | A monthly review of that access package, with decisions auto-applied when the review closes |
| [Post C1: Conditional Access](post-c1-conditional-access/) | MFA and legacy-auth blocking policies tested in Report-only first, with a break-glass account excluded before enforcement |
| [Post C2: Risk-based Conditional Access](post-c2-risk-based-ca/) | A user-risk policy, plus diagnosing a P2 licensing problem that blocked Identity Protection |

## midPoint (on-prem)

| Post | What it proves |
|---|---|
| [Post 10: midPoint + FreeIPA](post10-midpoint-freeipa/) | midPoint deployed in Docker and connected to FreeIPA over LDAP, with existing users imported |
| [Post 11: Role assignment + reconciliation](post11-reconciliation/) | Role-based provisioning and a reconciliation run confirming midPoint matches FreeIPA |

## Honest limits
These posts document what a single-user lab tenant could and couldn't prove:
- **C1:** the legacy-auth block never registered a "would block" result against a simulated legacy sign-in, likely because Microsoft exempts its own PowerShell client. Real proof needs IMAP/POP/EAS traffic against a licensed mailbox.
- **C2:** Identity Protection had no risky sign-ins to evaluate, so the risk policy was enforced on verified configuration, not observed behavior.
- **Post 11:** midPoint's group-membership push-out failed on a validation error that appears to be a product defect. I time-boxed it and shipped the working core: role-based provisioning and reconciliation.
