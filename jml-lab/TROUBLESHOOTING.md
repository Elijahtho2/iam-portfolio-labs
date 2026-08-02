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

## Post 4 - Mover: privilege-creep / stale-access example


**What broke:** First version of the Mover playbook only added jellis to
it-support and left the finance-analysts removal out on purpose, to show
what stale access looks like when a mover's old group never gets cleaned
up. Ran it, checked both groups, and yep — jellis was in finance-analysts
AND it-support at the same time. That's the broken state I wanted.

**Then a real bug showed up fixing it.** Went to add the removal task back
in and used state: absent on the ipa_group module, thinking that would
strip jellis out of the group. Instead it deleted finance-analysts
entirely. Turns out state on this module controls whether the GROUP
exists, not whether a user is a member of it — I had the parameter wrong.
Tried adding an "action" parameter next to fix it, thinking I could
control membership vs. group state separately. That's not a real param
on this module version either, so that attempt just errored out and left
jellis stuck in finance-analysts, unmoved.

**Fix:** Gave up on getting the ipa_group module's state/append/user
behavior to do what I wanted and rebuilt the task using ipa CLI commands
directly (ipa group-remove-member / ipa group-add-member) through
ansible.builtin.command, running under my own kinit'd admin ticket instead
of the ansible-svc vault credentials. Same commands I'd already run by
hand earlier to confirm the group logic worked — just wrapped in Ansible
instead of trusting the module to interpret my intent correctly.

**Why it's worth keeping in here:** Honestly a better example than the one
I planned. The whole point of this post is privilege creep — a mover who
keeps old access because the removal step silently doesn't happen. I
almost shipped an automation bug that does exactly that (removal task
either deletes the whole group or does nothing), which is a good reminder
that "the playbook ran with no errors" doesn't mean it did what you think
it did. Worth verifying state after every automated change, not just
trusting exit codes.
