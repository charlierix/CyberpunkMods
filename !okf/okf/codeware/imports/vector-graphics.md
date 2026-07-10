---
type: "Import"
title: "Vector-Graphics Types"
description: "Imported game engine types in the vector-graphics domain (12 types)."
resource: "codeware/scripts/"
tags: "[imports, vector-graphics]"
timestamp: 2026-07-01T18:09:33Z
---

# Overview

Imported game engine types in the vector-graphics domain (12 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| SvgResource | class | CResource | vectorGraphicDef |
| vgAttributeTypeValuePair | class | ISerializable | pe, lue |
| vgBaseVectorGraphicShape | class | ISerializable | calTransform, yle |
| vgEStyleAttributeType | enum | — | FillColor, StrokeColor, StrokeSize, StrokeMiterLimit, FontFamily |
| vgVectorGraphicDefinition | class | ISerializable | rootShapeGroup, dimensions |
| vgVectorGraphicShape_Circle | class | vgBaseVectorGraphicShape | dius |
| vgVectorGraphicShape_Group | class | vgBaseVectorGraphicShape | childShapes |
| vgVectorGraphicShape_PolyLine | class | vgBaseVectorGraphicShape | ints, roke |
| vgVectorGraphicShape_Polygon | class | vgBaseVectorGraphicShape | ints |
| vgVectorGraphicShape_Rect | class | vgBaseVectorGraphicShape | mensions |
| vgVectorGraphicShape_Text | class | vgBaseVectorGraphicShape | xt |
| vgVectorGraphicStyle | class | ISerializable | attributes |

# Citations

- `codeware/scripts/Base/Imports/SvgResource.reds`
- `codeware/scripts/Base/Imports/vgAttributeTypeValuePair.reds`
- `codeware/scripts/Base/Imports/vgBaseVectorGraphicShape.reds`
- `codeware/scripts/Base/Imports/vgEStyleAttributeType.reds`
- `codeware/scripts/Base/Imports/vgVectorGraphicDefinition.reds`
- `codeware/scripts/Base/Imports/vgVectorGraphicShape_Circle.reds`
- `codeware/scripts/Base/Imports/vgVectorGraphicShape_Group.reds`
- `codeware/scripts/Base/Imports/vgVectorGraphicShape_PolyLine.reds`
- `codeware/scripts/Base/Imports/vgVectorGraphicShape_Polygon.reds`
- `codeware/scripts/Base/Imports/vgVectorGraphicShape_Rect.reds`
- ... and 2 more source files
