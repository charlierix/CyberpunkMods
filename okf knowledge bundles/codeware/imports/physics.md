---
type: "Import"
title: "Physics Types"
description: "Imported game engine types in the physics domain (80 types)."
resource: "codeware/scripts/"
tags: "[imports, physics]"
timestamp: 2026-07-01T18:09:22Z
---

# Overview

Imported game engine types in the physics domain (80 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| ClothResetEvent | class | Event | — |
| PhysicalDeformShapesEvent | class | Event | shapes, value |
| PhysicalDestructionNode | class | worldNode | mesh, meshAppearance, forceLODLevel, forceAutoHideDistance, destructionParams |
| PhysicalFractureFieldNode | class | worldNode | shape, fractureFieldParams |
| PhysicalSkinnedMeshComponent | unknown | — | — |
| PhysicalTriggerComponent | unknown | — | — |
| PhysicsFunctionalTests | class | IScriptable | — |
| PhysicsParticleInitializer | class | ISerializable | — |
| RagdollComponent | class | IComponent | isEnabled |
| physicsApperanceMaterial | struct | — | apperanceName, material |
| physicsCacheEntry | struct | — | entryOffset |
| physicsCacheKey | struct | — | key |
| physicsColliderBox | class | physicsICollider | halfExtents, isObstacle |
| physicsColliderCapsule | class | physicsICollider | radius, height |
| physicsColliderConvex | class | physicsICollider | vertices, indexBuffer, polygonVertices |
| physicsColliderMesh | class | physicsICollider | faceMaterials |
| physicsColliderSphere | class | physicsICollider | radius |
| physicsCollisionFilterResource | class | ISerializable | collisionPresetJson, overridesJson, queryPresetJson, collisionGroups, queryGroups |
| physicsCollisionPresetDefinition | class | ISerializable | Name, Description, ForceEnableCollisionCallbacks, CollisionType, CollisionMask |
| physicsCollisionPresetOverride | struct | — | from |
| physicsCollisionPresetsOverridesResource | class | ISerializable | overrides |
| physicsCollisionPresetsResource | class | ISerializable | presets |
| physicsCustomFilterData | class | ISerializable | collisionType, collideWith, queryDetect |
| physicsDeferredCollection | class | ISerializable | — |
| physicsDestructionHierarchyOffset | struct | — | combined |
| physicsDestructionLevelData | struct | — | filterData |
| physicsDestructionParams | struct | — | startInactive, markEdgeChunks, turnDynamicOnImpulse, damageThreshold, bondEndurance |
| physicsFilterData | class | ISerializable | simulationFilter, queryFilter, preset, customFilterData |
| physicsFilterDataSource | enum | — | Parent, Collider, Component, Body |
| physicsFractureFieldEffect | enum | — | FE_Fracture, FE_Erase |
| physicsFractureFieldParams | struct | — | origin, destructionTypeMask, fractureFieldTypeMask, fractureFieldOptionsMask, fractureFieldEffect |
| physicsFractureFieldValueType | enum | — | FFVT_Impulse, FFVT_Velocity |
| physicsGeometryCache | class | CResource | sectorEntries, sectorGeometries, sectorCacheEntries, alwaysLoadedSector |
| physicsGeometryCacheArtifact | class | CResource | entryKeys, entryTable |
| physicsGeometryKey | struct | — | pe |
| physicsICollider | class | ISerializable | localToBody, material, materialApperanceOverrides, tag, isImported |
| physicsISystemObject | class | ISerializable | name |
| physicsMaterialFriction | enum | — | Enabled, DisabledStrong, Disabled |
| physicsMaterialLibraryResource | class | CResource | defaultMaterial |
| physicsMaterialReference | struct | — | name |
| physicsMaterialResource | class | CResource | staticFriction, dynamicFriction, restitution, frictionMode, density |
| physicsMaterialTagAIVisibility | enum | — | None, SemiTransparent, Transparent |
| physicsMaterialTagProjectilePenetration | enum | — | TechOnly, Any, Medium, Heavy, Never |
| physicsMaterialTagProjectileRicochet | enum | — | Default, Always |
| physicsMaterialTagType | enum | — | AIVisibility, PlayerVisibility, ProjectilePenetration, ProjectileRicochet, VehicleTraction |
| physicsMaterialTagVehicleTraction | enum | — | Default, Gravel |
| physicsMaterialTagVisibility | enum | — | None, SemiTransparent, Transparent, Ignore |
| physicsMaterialTags | struct | — | aiVisibility, projectilePenetration, vehicleTraction |
| physicsPhysicalJointPin | class | ISerializable | object, featureIndex, localPosition, localRotation |
| physicsPhysicalSystemOwner | enum | — | Unknown, BakedDestructionNode, ClothMeshNode, CollisionAreaNode, DecorationMeshNode |
| physicsPhysicsJointAxis | enum | — | AxisX, AxisY, AxisZ, Twist, Swing1 |
| physicsPhysicsJointDrive | struct | — | forceLimit, stiffness |
| physicsPhysicsJointDriveType | enum | — | AxisX, AxisY, AxisZ, Swing, Twist |
| physicsPhysicsJointDriveVelocity | struct | — | linearVelocity |
| physicsPhysicsJointLimitBase | struct | — | restitution, stiffness, contactDistance |
| physicsPhysicsJointMotion | enum | — | Locked, Limited, Free |
| physicsProxyType | enum | — | Invalid, PhysicalSystem, CharacterController, Destruction, ParticleSystem |
| physicsQueryPresetDefinition | class | ISerializable | name, queryGroups |
| physicsQueryPresetResource | class | ISerializable | presets |
| physicsQueryUseCase | enum | — | Default, ActionAnimation, AI, AnimationComponent, Audio |
| physicsRagdollBodyInfo | struct | — | ParentAnimIndex, ParentBodyIndex, ShapeType, HalfHeight, ShapeLocalRotation |
| physicsRagdollBodyNames | struct | — | ParentAnimName |
| physicsRagdollShapeType | enum | — | CAPSULE, BOX, SPHERE |
| physicsSectorCacheArtifact | class | CResource | sectorGeometryKeys, sectorInPlaceGeometry, sectorBounds |
| physicsSectorCacheEntry | struct | — | entryOffset |
| physicsSectorEntry | struct | — | sectorBounds, entryOffset |
| physicsShapeType | enum | — | Box, Sphere, Capsule, ConvexMesh, TriangleMesh |
| physicsSimulationType | enum | — | Static, Dynamic, Kinematic, Invalid |
| physicsStaticCollisionShapeCategory | enum | — | Interior, Exterior, Architecture, Decoration, Other |
| physicsStaticCollisionShapeDebugInfo | struct | — | sourceMeshPathHash, nodeNameHash |
| physicsSystemBody | class | physicsISystemObject | params, localToModel, collisionShapes, mappedBoneName, mappedBoneToBody |
| physicsSystemBodyParams | struct | — | simulationType, angularDamping, solverIterationsCountVelocity, maxAngularVelocity, mass |
| physicsSystemJoint | class | physicsISystemObject | localToWorld, pinA, pinB, linearLimit, twistLimit |
| physicsSystemResource | class | CResource | bodies, joints |
| physicsTriggerShape | struct | — | shapeType, shapeLocalPose |
| physicsclothClothCapsuleExportData | class | ISerializable | capsules |
| physicsclothExportedCapsule | struct | — | p0, r0, boneName |
| physicsclothPhaseConfig | struct | — | stiffness, compressionLimit |
| physicsclothRuntimeInfo | struct | — | translation, gravity, drag, numSolverIterations, friction |
| physicsclothState | struct | — | verticalPhaseData, bendPhaseData, runtimeInfo |

# Citations

- `codeware/scripts/Base/Imports/ClothResetEvent.reds`
- `codeware/scripts/Base/Imports/PhysicalDeformShapesEvent.reds`
- `codeware/scripts/Base/Imports/PhysicalDestructionNode.reds`
- `codeware/scripts/Base/Imports/PhysicalFractureFieldNode.reds`
- `codeware/scripts/Base/Imports/PhysicalSkinnedMeshComponent.reds`
- `codeware/scripts/Base/Imports/PhysicalTriggerComponent.reds`
- `codeware/scripts/Base/Imports/PhysicsFunctionalTests.reds`
- `codeware/scripts/Base/Imports/PhysicsParticleInitializer.reds`
- `codeware/scripts/Base/Imports/RagdollComponent.reds`
- `codeware/scripts/Base/Imports/physicsApperanceMaterial.reds`
- ... and 70 more source files
