---
type: "Import"
title: "Interactions Types"
description: "Imported game engine types in the interactions domain (50 types)."
resource: "codeware/scripts/"
tags: "[imports, interactions]"
timestamp: 2026-07-01T18:09:17Z
---

# Overview

Imported game engine types in the interactions domain (50 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| gameinteractionsAlwaysSamePredicate | class | gameinteractionsIPredicateType | priority |
| gameinteractionsBumpType | enum | — | Workspot, Crowd |
| gameinteractionsCAabbDefinition | class | gameinteractionsIShapeDefinition | min, max |
| gameinteractionsCFunctorDefinition | class | gameinteractionsIFunctorDefinition | predicate, unaryOperator |
| gameinteractionsCHotSpotAreaFilterDefinition | class | gameinteractionsNodeDefinition | slotName, transform, functor, shapes, negativeShapes |
| gameinteractionsCHotSpotDefinition | struct | — | suppressor |
| gameinteractionsCHotSpotGameLogicFilterDefinition | class | ISerializable | hotSpotPrereq, activatorPrereq, scriptedConditionClass |
| gameinteractionsCLinkedLayersDefinition | class | gameinteractionsNodeDefinition | layersDefinitions, visualizerDefinition, tag |
| gameinteractionsCOrientedBoxDefinition | class | gameinteractionsIShapeDefinition | position, forward, right, up |
| gameinteractionsCPredicateDefinition | struct | — | predicateType, functor1DataDefinition |
| gameinteractionsCSharedDataDefinition | struct | — | defaultChoices |
| gameinteractionsCSphereDefinition | class | gameinteractionsIShapeDefinition | position, radius |
| gameinteractionsChoiceLookAtDescriptor | struct | — | type, offset |
| gameinteractionsChoiceLookAtType | enum | — | Root, Slot, Orb |
| gameinteractionsConeDefinition | class | gameinteractionsIShapeDefinition | pos1, pos2, radius1, radius2 |
| gameinteractionsContainedInShapesPredicate | class | gameinteractionsIPredicateType | useCameraPosition |
| gameinteractionsDistanceFromScreenCenterPredicate | class | gameinteractionsIPredicateType | height, width, curvature, maxPriorityBoundsFactor |
| gameinteractionsEBinaryOperator | enum | — | EBinaryOperator_and, EBinaryOperator_or |
| gameinteractionsEGroupType | enum | — | EGT_default, EGT_noInput, EGT_hint |
| gameinteractionsELookAtTarget | enum | — | Entity, Component |
| gameinteractionsELookAtTest | enum | — | Targeting, Interaction |
| gameinteractionsEPredicateType | enum | — | EPredicateFunction_true, EPredicateFunction_distanceFromScreenCentre, EPredicateFunction_containedInShapes, EPredicateFunction_onScreenTest, EPredicateFunction_visibleTarget |
| gameinteractionsEUnaryOperator | enum | — | EUnaryOperator_empty, EUnaryOperator_not |
| gameinteractionsHotSpotActivationResult | struct | — | priority |
| gameinteractionsIFunctorDefinition | class | ISerializable | — |
| gameinteractionsIPredicateType | class | ISerializable | — |
| gameinteractionsIShapeDefinition | class | ISerializable | — |
| gameinteractionsInteractionDefinitionOverrider | struct | — | tag, negativeShapes |
| gameinteractionsInteractionDescriptorResource | class | CResource | definition |
| gameinteractionsLayerActivatedPredicate | class | gameinteractionsIPredicateType | linkedLayersName, layerName |
| gameinteractionsLookAtPredicate | class | gameinteractionsIPredicateType | testTarget, testType, stopOnTransparent |
| gameinteractionsOnScreenTestPredicate | class | gameinteractionsIPredicateType | — |
| gameinteractionsOrbActivationPredicate | class | gameinteractionsIPredicateType | — |
| gameinteractionsOrbID | struct | — | id |
| gameinteractionsPieDefinition | class | gameinteractionsIShapeDefinition | center, baseLength, halfExtentZ, radius, angle |
| gameinteractionsPublisherBaseEvent | unknown | — | — |
| gameinteractionsSuppressedPredicate | class | gameinteractionsIPredicateType | — |
| gameinteractionsVisibleTargetPredicate | class | gameinteractionsIPredicateType | stopOnTransparent |
| gameinteractionsvisDeviceVisualizerDefinition | class | gameinteractionsvisIVisualizerDefinition | interactionType, displayNameOverride, useDefaultActionMapping, createMappin, isDynamic |
| gameinteractionsvisDeviceVisualizerLogic | class | gameinteractionsvisIGroupedVisualizerLogic | — |
| gameinteractionsvisDialogVisualizerDefinition | class | gameinteractionsvisIVisualizerDefinition | displayNameOverride, useLookAt, disableAfterSelectingChoice, timeProvider, hubPriority |
| gameinteractionsvisDialogVisualizerLogic | class | gameinteractionsvisIGroupedVisualizerLogic | — |
| gameinteractionsvisFamilyBase | unknown | — | — |
| gameinteractionsvisIGroupedVisualizerLogic | class | gameinteractionsvisIVisualizerLogicInterface | — |
| gameinteractionsvisIVisualizerDefinition | class | ISerializable | flags |
| gameinteractionsvisIVisualizerLogicInterface | class | ISerializable | — |
| gameinteractionsvisInteractionDisplayData | struct | — | putAction, HoldAction, pe |
| gameinteractionsvisInteractionType | enum | — | LookAt, Proximity |
| gameinteractionsvisLootVisualizerDefinition | class | gameinteractionsvisIVisualizerDefinition | — |
| gameinteractionsvisLootVisualizerLogic | class | gameinteractionsvisIVisualizerLogicInterface | — |

# Citations

- `codeware/scripts/Base/Imports/gameinteractionsAlwaysSamePredicate.reds`
- `codeware/scripts/Base/Imports/gameinteractionsBumpType.reds`
- `codeware/scripts/Base/Imports/gameinteractionsCAabbDefinition.reds`
- `codeware/scripts/Base/Imports/gameinteractionsCFunctorDefinition.reds`
- `codeware/scripts/Base/Imports/gameinteractionsCHotSpotAreaFilterDefinition.reds`
- `codeware/scripts/Base/Imports/gameinteractionsCHotSpotDefinition.reds`
- `codeware/scripts/Base/Imports/gameinteractionsCHotSpotGameLogicFilterDefinition.reds`
- `codeware/scripts/Base/Imports/gameinteractionsCLinkedLayersDefinition.reds`
- `codeware/scripts/Base/Imports/gameinteractionsCOrientedBoxDefinition.reds`
- `codeware/scripts/Base/Imports/gameinteractionsCPredicateDefinition.reds`
- ... and 40 more source files
