# Post 13 — Static Secrets: Credential Vaulting

## What I did
- Enabled Vault's KV v2 secrets engine at a dedicated path (lab-secrets).
- Stored a sample credential pair and retrieved it back via the CLI.

## Screenshot
![KV secret stored and retrieved](vault-kv-get.png)

## Why it matters
This is the baseline PAM use case: an application asks Vault for a credential at
runtime instead of that credential sitting hardcoded in a config file or script.
It's a small step technically, but it's the piece that makes every later, fancier
capability (dynamic secrets, leasing, policies) possible — they're all built on
top of this same secrets-engine model.

