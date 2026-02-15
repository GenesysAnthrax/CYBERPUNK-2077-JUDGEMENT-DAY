# Night City Sandbox (Cyber Engine Tweaks Mod)

A **Cyberpunk 2077** mod prototype that turns Night City into a more reactive sandbox.

## What this mod adds

- **Dynamic Heat System**
  - Violent or reckless actions build district heat.
  - Heat slowly decays over time when you lay low.
  - Higher heat increases police escalation.

- **Faction Reputation**
  - Your actions impact major factions (NCPD, Gangs, Corps, Citizens).
  - Positive/negative reputation changes ambient reactions and encounter weighting.

- **Action Consequences Ledger**
  - A rolling memory of key player actions.
  - Consequences trigger delayed world responses (ambushes, discounts, hostility).

- **Adaptive World Pulse**
  - Every in-game interval, the mod evaluates your state and applies outcome events.
  - Consequences are contextual and probabilistic, so the city feels less scripted.

---

## Requirements

- Cyberpunk 2077
- [Cyber Engine Tweaks](https://www.nexusmods.com/cyberpunk2077/mods/107)

## Installation

1. Install Cyber Engine Tweaks.
2. Copy the `mods/NightCitySandbox` folder into your game's CET mods directory:
   - `.../Cyberpunk 2077/bin/x64/plugins/cyber_engine_tweaks/mods/NightCitySandbox`
3. Launch the game.
4. Open CET overlay and verify `NightCitySandbox` logs are visible.

## How to use

- Play normally. The system listens for action hooks and updates world state.
- Use CET console:
  - `NCS.DebugState()` prints current heat/reputation/consequence status.
  - `NCS.AddHeat("watson", 20)` manually test heat.
  - `NCS.AdjustFaction("gangs", -10)` manually test faction reaction.

## Design notes

This is a framework-first mod intended to be expanded with additional hooks:

- Mission outcome parsing
- Kill/KO/stealth telemetry
- Economy behavior (vendor prices tied to rep)
- Dynamic radio/news callbacks
- Street-level AI behavior packages by district mood

## File layout

- `mods/NightCitySandbox/init.lua` - CET entry point and event wiring
- `mods/NightCitySandbox/config.lua` - balancing config
- `mods/NightCitySandbox/modules/state.lua` - persistent player/world state
- `mods/NightCitySandbox/modules/events.lua` - reaction logic and consequence resolution
- `mods/NightCitySandbox/modules/ui.lua` - debug utilities + console API

## Compatibility

- Built as a standalone CET mod.
- Should coexist with most script/content mods unless they heavily alter the same systems.

## License

MIT
