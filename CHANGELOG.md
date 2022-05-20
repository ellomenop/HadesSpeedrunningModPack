
# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/), and will follow [Semantic Versioning](https://semver.org/).

## [1.2.0] - TBD (rc.4 released 2021-05-19)

### Added

 - Can now toggle guaranteed Charon Sack spawn for Loyalty Card
 - QuickRestart now sets a flag for the Livesplit autosplitter to reset

### Changed
 - QuickRestart spawns you in the Courtyard instead of the blood pool
 - QuickRestart re-equips your starting keepsake
 - RtaTimer is now more efficient - should remove any lag issues that it was causing
 - Default Hammer for Rama Aspect of the Bow is now Twin Shot
 - Renamed sgg-mod-modutil to reduce duplicate ModUtil user installs

### Bug fixes
 - ShowChamberNumber now works with newer versions of modimporter

## [1.1.1] - 2021-09-14

### Added

 - Can now toggle Hell Mode in mod settings

### Removed

 - Starting Boon Selector was not legal on any rulesets

### Changed

 - Clarified ruleset text
 - Cleaned up menu and credits

### Bug fixes

 - Remove Approval Process blocking on the DontGetVorimed boon
 - Slight delay before QuickRestart to remove interaction bugs

## [1.1.0] - 2021-08-01

### Added

 - Single-run ruleset

### Changed

 - Quick Restart also resets RtaTimer
 - Replaced FixedHammers with RunStartControl
 - Asterius removed from Leaderboard ruleset

### Bug fixes

 - Can no longer reset during the pause before Thanatos Encounter spawns to prevent broken GameState



## [1.0.0] - 2021-06-04

No major bugs were found with v1.0.0-rc.2 so we are moving forward with leaderboard creation!

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
