---
type: "API"
title: "Reflection System"
description: "Runtime type introspection system for classes, enums, functions, and properties."
resource: "codeware/scripts/"
tags: "[reflection]"
timestamp: 2026-07-01T18:08:59Z
---

# Overview

Runtime type introspection system for classes, enums, functions, and properties.

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| ERTTIType | enum | — | Name, Fundamental, Class, Array, Simple |
| Reflection | struct | — | — |
| ReflectionClass | class | ReflectionType | GetAlias, GetParent, GetProperty, GetFunction, GetStaticFunction |
| ReflectionEnum | class | ReflectionType | GetConstants, IsNative, AddConstant, GetConstants, IsNative |
| ReflectionFunc | class | — | GetName, GetFullName, GetParameters, GetReturnType, IsNative |
| ReflectionProp | class | — | GetName, GetType, IsNative, GetValue, SetValue |
| ReflectionType | class | — | GetName, GetMetaType, GetInnerType, MakeInstance, IsArray |

# Citations

- `codeware/scripts/Reflection/ERTTIType.reds`
- `codeware/scripts/Reflection/Reflection.reds`
- `codeware/scripts/Reflection/ReflectionClass.reds`
- `codeware/scripts/Reflection/ReflectionEnum.reds`
- `codeware/scripts/Reflection/ReflectionFunc.reds`
- `codeware/scripts/Reflection/ReflectionProp.reds`
- `codeware/scripts/Reflection/ReflectionType.reds`
