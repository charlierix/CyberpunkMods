---
type: "Import"
title: "Quest Types/Phone"
description: "Imported quest types/phone types (5 types)."
resource: "codeware/scripts/"
tags: "[imports, phone]"
timestamp: 2026-07-01T18:09:23Z
---

# Overview

Imported quest types/phone types (5 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| questPhoneCallMode_ConditionType | class | questIPhoneConditionType | callMode |
| questPhoneCallPhase_ConditionType | class | questIPhoneConditionType | callPhase |
| questPhoneMuted_ConditionType | class | questISystemConditionType | groupName, inverted |
| questPhonePickUp_ConditionType | class | questISystemConditionType | caller, addressee, releaseOnRejection |
| questPhone_ConditionType | class | questISystemConditionType | caller, addressee, callPhase |

# Citations

- `codeware/scripts/Base/Imports/questPhoneCallMode_ConditionType.reds`
- `codeware/scripts/Base/Imports/questPhoneCallPhase_ConditionType.reds`
- `codeware/scripts/Base/Imports/questPhoneMuted_ConditionType.reds`
- `codeware/scripts/Base/Imports/questPhonePickUp_ConditionType.reds`
- `codeware/scripts/Base/Imports/questPhone_ConditionType.reds`
