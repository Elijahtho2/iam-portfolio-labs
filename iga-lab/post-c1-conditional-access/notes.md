## Post C1 — Conditional Access: MFA for Admins + Block Legacy Auth

### What I did
Built two Conditional Access policies in the IronForgeAI Entra ID tenant, both
set to Report-only first:

- LAB-CA-Require-MFA-Admins — requires MFA, scoped to All users
- LAB-CA-Block-Legacy-Auth — blocks access, scoped to All users, targeting
  legacy authentication clients (Exchange ActiveSync clients + Other clients)

### What I validated
To generate a real signal instead of waiting on organic traffic in a
single-user lab tenant, I simulated a legacy authentication attempt using a
ROPC (Resource Owner Password Credentials) request via PowerShell.

LAB-CA-Require-MFA-Admins fired exactly as expected: Report-only result
"User action required."

### What I attempted but hit a real limitation
LAB-CA-Block-Legacy-Auth never returned a "would block" result against the
same sign-in, despite verified-correct configuration (scope: All users, no
exclusion; Client apps condition: Exchange ActiveSync + Other clients both
checked) and the sign-in log itself classifying the client app as "Other."
Working theory: the ROPC client ID used (Microsoft's own Azure AD PowerShell
client) may be exempted from legacy-auth Conditional Access matching, since
Microsoft is known to protect its own admin tooling from being broken by
legacy-auth blocks. Genuine validation would require real IMAP/POP/EAS
traffic against a licensed mailbox, unavailable in this lab tenant.

### Why this matters
A policy being correctly configured and a policy being provably triggered
in testing are two different claims. Knowing what a test actually proved —
and saying plainly what it didn't — matters more than a clean result.

### Decision
Re-excluded the break-glass admin account from both policies, then moved
Enable policy from Report-only to On for both.

