---
type: "Import"
title: "Animation Types/Dyng"
description: "Imported animation types/dyng types (8 types)."
resource: "codeware/scripts/"
tags: "[imports, dyng]"
timestamp: 2026-07-01T18:09:02Z
---

# Overview

Imported animation types/dyng types (8 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| animDyngConstraintCone | class | animIDyngConstraint | constrainedBone, coneAttachmentBone, coneTransformLS, constraintType, halfOfMaxApertureAngle |
| animDyngConstraintEllipsoid | class | animIDyngConstraint | bone, ellipsoidTransformLS, constraintRadius, constraintScale1, constraintScale2 |
| animDyngConstraintLink | class | animIDyngConstraint | bone1, bone2, linkType, lengthLowerBoundRatioPercentage, lengthUpperBoundRatioPercentage |
| animDyngConstraintLinkType | enum | — | KeepFixedDistance, KeepVariableDistance, Greater, Closer |
| animDyngConstraintMulti | class | animIDyngConstraint | innerConstraints |
| animDyngParticle | struct | — | mass, pullForceFactor, bone, collisionCapsuleHeightExtent, projectionType |
| animDyngParticleProjectionType | enum | — | Disabled, ShortestPath, Directed |
| animDyngParticlesContainer | struct | — | externalForceWS, particles |

# Citations

- `codeware/scripts/Base/Imports/animDyngConstraintCone.reds`
- `codeware/scripts/Base/Imports/animDyngConstraintEllipsoid.reds`
- `codeware/scripts/Base/Imports/animDyngConstraintLink.reds`
- `codeware/scripts/Base/Imports/animDyngConstraintLinkType.reds`
- `codeware/scripts/Base/Imports/animDyngConstraintMulti.reds`
- `codeware/scripts/Base/Imports/animDyngParticle.reds`
- `codeware/scripts/Base/Imports/animDyngParticleProjectionType.reds`
- `codeware/scripts/Base/Imports/animDyngParticlesContainer.reds`
