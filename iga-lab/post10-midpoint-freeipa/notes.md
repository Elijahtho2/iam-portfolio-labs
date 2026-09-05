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
