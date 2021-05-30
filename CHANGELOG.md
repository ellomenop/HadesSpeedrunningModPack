
# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/), and will follow [Semantic Versioning](https://semver.org/).

## [1.0.0-rc.2] - 2021-05-30

### Changed

- Quick Restart (insta-kill) can only be activated if
  - Zagreus is not in the house
  - Zagreus is not frozen (cutscenes, boon pickups, room endings)
  - Combat UI is visible

 This is to prevent a variety of bugs, from duplicated boons to crashes. [#39](https://github.com/ellomenop/HadesSpeedrunningModPack/pull/39)

- BoonSelector now has all filters enabled by default, and the rarity filter will be disabled automatically if "DontGetVorimed" is enabled. [#45](https://github.com/ellomenop/HadesSpeedrunningModPack/pull/45)

- EmoteMod has been disabled due to an unknown issue with MacOS [#48](https://github.com/ellomenop/HadesSpeedrunningModPack/pull/48)

### Fixed

- MinibossControl now forces the correct amount of miniboss doors in Asphodel. [#38](https://github.com/ellomenop/HadesSpeedrunningModPack/pull/38)

- MinibossControl now enforces changes on save reload. [#38](https://github.com/ellomenop/HadesSpeedrunningModPack/pull/38)

## [1.0.0-rc.1] - 2021-05-27

Initial "Beta" release of the modpack. This includes:

- Colorblind
- DontGetVorimed
- DoorVisualIndicators
- StartingBoonSelector
- EmoteMod
- ErumiUILib
- FixedHammers
- HadesSpeedrunningModpack
- InteractableChaos
- LootChoiceExt
- MinibossControl
- ModConfigMenu
- ModUtil
- ModdedWarning
- PrintUtil
- QuickRestart
- RemoveCutscenes
- RoomDeterminism
- RTATimer
- SatyrSackControl
- ShowChamberNumber
- ThanatosControl

as well as a ruleset preset for "Multiweapon Leaderboard" runs.