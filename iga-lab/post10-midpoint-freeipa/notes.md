# Post 10 — midPoint + FreeIPA
 
## What I did
- Installed Docker and deployed midPoint via the official quickstart script
  on gov-auth.
- Connected midPoint to the FreeIPA directory (from the JML lab) as a
  resource, using the generic LDAP/ConnId connector.
- Ran Test connection — all capabilities (schema, connector, connection)
  returned green.
- Imported existing FreeIPA users into midPoint as shadow accounts.
 
## Screenshot

![midPoint resource connection test] (post10-midPoint-resource-connection-test-green-checks.png)


## Why it matters
Not every organization can license Entra ID Governance — a lot of GovTech
and mid-size shops run an open-source IGA stack like midPoint against an
existing directory instead. This shows the same governance concepts
(resources, roles, reconciliation) working on-prem, against the same
FreeIPA directory the JML lab automation provisions into.

