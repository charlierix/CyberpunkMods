---
type: "Import"
title: "Animation Types/Dangle"
description: "Imported animation types/dangle types (6 types)."
resource: "codeware/scripts/"
tags: "[imports, dangle]"
timestamp: 2026-07-01T18:09:02Z
---

# Overview

Imported animation types/dangle types (6 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| animDangleConstraint_Simulation | class | ISerializable | collisionRoundedShapes, jsonCollisionShapes, jsonCollisionShapesLoadedSuccessfully, alpha, rotateParentToLookAtDangle |
| animDangleConstraint_SimulationDyng | class | animDangleConstraint_Simulation | HACK_checkDangleTeleport, substepTime, solverIterations, particlesContainer, dyngConstraint |
| animDangleConstraint_SimulationPendulum | class | animDangleConstraint_SimulationSingleBone | constraintType, halfOfMaxApertureAngle, mass, damping, pullForceFactor |
| animDangleConstraint_SimulationPositionProjection | class | animDangleConstraint_SimulationSingleBone | collisionCapsuleRadius, collisionCapsuleHeightExtent, collisionCapsuleAxisLS, directionReferenceBone, projectionType |
| animDangleConstraint_SimulationSingleBone | class | animDangleConstraint_Simulation | dangleBone |
| animDangleConstraint_SimulationSpring | class | animDangleConstraint_SimulationSingleBone | constraintSphereRadius, constraintScale1, constraintScale2, mass, damping |

# Citations

- `codeware/scripts/Base/Imports/animDangleConstraint_Simulation.reds`
- `codeware/scripts/Base/Imports/animDangleConstraint_SimulationDyng.reds`
- `codeware/scripts/Base/Imports/animDangleConstraint_SimulationPendulum.reds`
- `codeware/scripts/Base/Imports/animDangleConstraint_SimulationPositionProjection.reds`
- `codeware/scripts/Base/Imports/animDangleConstraint_SimulationSingleBone.reds`
- `codeware/scripts/Base/Imports/animDangleConstraint_SimulationSpring.reds`
