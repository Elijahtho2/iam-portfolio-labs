# Post 11 – Role Assignment + Reconciliation (Lab 2 Complete)

## What I did
- Built a role in midPoint (News-Team-Role) linked to the FreeIPA LDAP resource,
  granting account provisioning (Kind=Account/Intent=default) on assignment.
- Assigned the role to an imported FreeIPA user (jellis) and confirmed the
  assignment took effect.
- Ran a Reconciliation task against the resource — confirmed midPoint's view of
  accounts matches what's actually in FreeIPA, with Success/Failure/Skip
  counts visible under Operation statistics.

## What I attempted but hit a real limitation
- Tried to configure LDAP group-membership push-out (adding a user to a
  `groupOfNames` group's `member` attribute automatically on role assignment)
  using midPoint's newer "simulated references" / Association types feature.
- Configured the association type multiple times with the fields midPoint's
  own validation error asked for (Name, Direction=Object-to-subject, Subject/
  Object primary binding attributes, and Delineation objectClass on both
  sides matching the resource's actual schema — inetOrgPerson / groupOfNames).
- Every save attempt failed with the identical validation error:
  "No delineations in subject specification in simulated reference type
  'group' definition..." — even after the missing field was added exactly as
  the error described.
- Found supporting evidence this is a product defect rather than a
  configuration mistake: part of the wizard rendered an untranslated internal
  key (`SimulatedReferenceTypeParticipantDelineationType.details.newValue`)
  instead of a human-readable label — a sign this feature isn't fully wired
  up in this midPoint version/build.
- Decision: rather than burn more time chasing an apparent UI bug in a
  secondary feature, documented the limitation and moved forward with the
  core IGA capability already fully working — role-based provisioning,
  real account imports, and reconciliation.

## Why this matters
Knowing when to time-box a rabbit hole, document a vendor limitation, and
ship the core capability is itself a real IGA/operations skill — production
environments hit unfinished vendor features constantly, and the job isn't to
get stuck, it's to recognize the defect, work around it, and keep the
program moving.

## Screenshot moment (Post 11): role assignment → reconciliation report →
the association-type validation error (as evidence of the documented limitation)

![ role assignment ](post11-role-assignment)

![ group membership](post11-group-membership)

![ reconciliation report ](post11-reconciliation-report)

![ association validation error ](post11-association-validation-error)

