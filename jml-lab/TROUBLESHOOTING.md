# Troubleshooting Log: JML Lab

Each issue is written as Symptom → Root cause → Fix → Verification.

## Issue 1: Mover playbook deleted a whole group instead of removing one member

**Context:** Post 4 was meant to show privilege creep. The first Mover version deliberately added `jellis` to `it-support` without removing `finance-analysts`, and checking both groups confirmed the stale-access state. Adding the removal step back is where a real bug appeared.

- **Symptom:** After the Mover ran, the `finance-analysts` group no longer existed. It happened twice before I recognized the pattern. A second attempt with an `action` parameter errored out and left `jellis` in `finance-analysts`, unmoved.
- **Root cause:** In `community.general.ipa_group`, `state: absent` controls whether the *group* exists, not whether a user is a member. `action` is not a valid parameter in that module version.
- **Fix:** Rewrote the membership tasks in `phase2_mover.yml` and `phase3_leaver.yml` to call `ipa group-remove-member`, `ipa group-add-member`, and `ipa user-disable` through `ansible.builtin.command`, authenticated with the operator's Kerberos ticket. These are the same commands I had already verified by hand.
- **Verification:** A full lifecycle run completed cleanly, with the Mover reporting the removal and the add as separate changed tasks ([jml-automation.log](jml-automation.log)).
- **Lesson:** "Ran with no errors" doesn't mean it did what you intended. An automation bug like this produces exactly the privilege creep the lab was built to demonstrate, so verify state after every change.

## Issue 2: Successful change reported as a failure

- **Symptom:** The Joiner's "Add user to department group" task failed with an empty-list API response, but `ipa user-show` confirmed `jellis` had been added to `finance-analysts`.
- **Root cause:** community.general 13.2.0 doesn't support ansible-core 2.16.14. A compatibility warning appeared on every run, and the module misread a real success as a failure.
- **Fix:** Pinned community.general to 8.6.0.
- **Verification:** The task reported `changed` and FreeIPA showed the matching membership.
- **Lesson:** When a task's status and the system state disagree, check the system directly and read the warnings above the failure.

## Issue 3: Least-privilege deny test gave a false pass

- **Symptom:** Testing `ansible-svc`'s scoped role with `ipa host-find` never returned a permission error.
- **Root cause:** `host-find` is a read operation, and FreeIPA lets any authenticated user read host records. The role was working; the test wasn't checking a boundary the role enforces.
- **Fix:** Switched to a write test: `ipa host-add fake-test-host.govlab.local --force`.
- **Verification:** Returned "Insufficient access: Insufficient 'add' privilege", proving `ansible-svc` can manage users and groups but not hosts.
- **Lesson:** In FreeIPA, test role scoping with write operations, not reads.

## Issue 4: Lifecycle script reported success after failed phases

- **Symptom:** The first full run printed "JOINER complete" and "full lifecycle done" even though the Joiner failed on vault decryption and the Leaver failed with `no such entry`.
- **Root cause:** The script didn't check exit codes. An incorrect vault password made the Joiner fail, so `jellis` was never created and the Leaver had no user to disable.
- **Fix:** Corrected the vault password and added a per-phase exit-code check to `run_full_lifecycle.sh` that logs the failure and stops the run.
- **Verification:** The next run completed all three phases with `failed=0` in each recap ([jml-automation.log](jml-automation.log)).
- **Lesson:** A wrapper that hides failures is worse than no wrapper. Every stage needs to prove it succeeded before the next one starts.
