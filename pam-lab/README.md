# Lab 3: Privileged Access (HashiCorp Vault + FreeIPA)

Builds privileged access controls on the RHEL lab: Vault on Gov-Auth, with Gov-App as the protected server.

| Post | What it proves |
|---|---|
| [Post 12: Vault installed](post12-vault-installed/) | Vault installed, initialized, and unsealed; unseal keys kept out of the repo |
| [Post 13: Secrets + least privilege](post13-static-secrets/) | KV v2 secrets engine and a read-only policy; the scoped token can read but is denied writes |
| [Post 14: Just-in-time SSH](post14-jit-ssh-setup/) | SSH to Gov-App requires a one-time password issued by Vault; normal account passwords are rejected |
| [Post 15: Revocation + JML integration](post15-jit-access-jml-integration/) | Issued SSH credentials revoked by hand and by the JML Leaver, using a token scoped only to revocation |

Post 15 ties this lab to the JML Leaver: on offboarding it revokes any outstanding Vault SSH leases under `gov-app-role` and verifies none remain.

## Known lab shortcuts
- Single-node Vault with file storage and manual unseal. Production would use Raft storage, TLS, and auto-unseal.
- Initial setup used the root token. Production would revoke it after creating scoped admin policies. (Automation already runs on a scoped token; see Post 15.)
