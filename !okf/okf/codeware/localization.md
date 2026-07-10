---
type: "API"
title: "Localization System"
description: "Localization system with entries, providers, watchers, and translation requests."
resource: "codeware/scripts/"
tags: "[localization]"
timestamp: 2026-07-01T18:08:59Z
---

# Overview

Localization system with entries, providers, watchers, and translation requests.

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| EntryType | enum | — | Interface, Subtitle |
| GenderNeutralEntry | class | LocalizationEntry | GetVariant, SetVariant, Create |
| GenderSensitiveEntry | class | LocalizationEntry | GetVariant, SetVariant, Create |
| LocalizationEntry | unknown | — | — |
| PlayerGender | enum | — | Female, Male, Default |
| LocalizationSystem | class | ScriptableSystem | GetInterfaceLanguage, GetSubtitleLanguage, GetVoiceLanguage, GetPlayerGender, GetText |
| ModLocalizationPackage | unknown | — | — |
| ModLocalizationProvider | unknown | — | — |
| RegisterProviderRequest | class | ScriptableSystemRequest | GetProvider, Create |
| UpdateGenderRequest | class | ScriptableSystemRequest | Create |
| UpdateLocaleRequest | class | ScriptableSystemRequest | GetType, Create |
| UpdateTranslationsRequest | class | ScriptableSystemRequest | IsForced, Create |
| LanguageSettingsWatcher | class | ConfigVarListener | Initialize, Start |
| PlayerGenderWatcher | class | — | Initialize, Start, Stop |

# Citations

- `codeware/scripts/Localization/Data/EntryType.reds`
- `codeware/scripts/Localization/Data/GenderNeutralEntry.reds`
- `codeware/scripts/Localization/Data/GenderSensitiveEntry.reds`
- `codeware/scripts/Localization/Data/LocalizationEntry.reds`
- `codeware/scripts/Localization/Data/PlayerGender.reds`
- `codeware/scripts/Localization/LocalizationSystem.reds`
- `codeware/scripts/Localization/Module/ModLocalizationPackage.reds`
- `codeware/scripts/Localization/Module/ModLocalizationProvider.reds`
- `codeware/scripts/Localization/Requests/RegisterProviderRequest.reds`
- `codeware/scripts/Localization/Requests/UpdateGenderRequest.reds`
- ... and 4 more source files
