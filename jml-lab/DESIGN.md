
# JML Lab - Design Doc

## Scope


This lab automates the Joiner-Mover-Leaver identity lifecycle against an on-prem FreeIPA directory. Entra ID / cloud sync is out of scope for this lab -- that is covered separately in the IGA lab.

## Persona

| Field | Value |
|---|---|
| Username | jellis |
| Full Name | Jordan Ellis |
| Starting department / role | Finance - Financial Analyst |
| Starting Group | finance-analysts |
| Mover destination | IT - IT Support Specialist |
| Mover destination group | it-support |
| Manager (existing test account) | admin (stand-in) |

## Lifecycle -> System Impact

| Stage | FreeIPA objects touched | Notes |
|---|---|---|
| Joiner | Creates user record + adds to finance-analysts group| New hire persona |
| Mover | Removes finance-analysts membership, adds it-support membership |
Department transfer persona |
| Leaver | Disable user account + removes all group memberships | Termination persona |

