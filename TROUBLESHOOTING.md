# Troubleshooting Log: JML Lab

## Issue 1: Group deleted instead of member removed
- **Symptom:** Security group `finance-analysts` disappeared after the leaver playbook ran. It happened twice before I recognized the pattern.
- **Root cause:** `community.general.ipa_group` with `state: absent` deletes the whole group, not a single member.
- **Fix:** Rewrote `phase2_mover.yml` and `phase3_leaver.yml` to call `ipa group-remove-member`, `ipa group-add-member`, and `ipa user-disable` via `ansible.builtin.command`, authenticated with the operator's kinit'd Kerberos ticket.
- **Verification:** Full lifecycle run (Joiner, Mover, Leaver) completed cleanly with per-phase exit-code checks.
- **Lesson:** Test destructive states against a disposable group first, and read module semantics before trusting state parameters.

## Issue 2: Successful changes reported as failures
- **Symptom:** Group membership changes succeeded but Ansible reported failure.
- **Root cause:** Version mismatch between community.general and ansible-core 2.16.14.
- **Fix:** Pinned community.general to 8.6.0.
