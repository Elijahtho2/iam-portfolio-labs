### Issue: initial least-privilege deny-test gave a false pass
**Symptom:** testing ansible-svc's scoped role with `ipa host-find <hostname>`
never returned a permission error, no matter which hostname was used —
it either found 0 matches or (if a real host existed) would have returned
it successfully either way.

**Cause:** `host-find` is a READ/search operation. FreeIPA grants read
access to host records to any authenticated user by default, regardless
of role membership. The "JML Automation Operator" role (User/Group
Administrators only) was working correctly the whole time — the test
itself just wasn't checking a boundary that role actually enforces.

**Fix:** switched the deny-test to a WRITE operation instead:
`ipa host-add fake-test-host.govlab.local --force`. This correctly
returned "Insufficient access: Insufficient 'add' privilege..." — proving
ansible-svc can manage users/groups but cannot create hosts.

**Takeaway:** read operations don't reliably test role scoping in FreeIPA —
only write operations do. Worth remembering for any future least-privilege
verification in this lab.

### Issue: playbook reported failure despite the change actually succeeding
**Symptom:** "Add user to department group" task failed with a cryptic
empty-list API response: {'member': {'user': [], 'group': [], ...}}.
Yet ipa user-show/group-show confirmed jellis WAS correctly added to
finance-analysts.

**Cause:** version mismatch — community.general 13.2.0 does not support
ansible-core 2.16.14 (flagged by an easily-missed warning on every run).
The module's response-parsing logic didn't match what this ansible-core
version's API client actually returned, so a real success was misread
as a failure.

**Fix:** pinned community.general to 8.6.0, a version compatible with
ansible-core 2.16.14.

**Takeaway:** don't trust a task's changed/failed status at face value
when a collection version-compatibility warning is present earlier in
the output — verify the actual system state directly when the two
seem to disagree.
