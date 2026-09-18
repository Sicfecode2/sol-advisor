# Neon Courier

Neon Courier is a small, replayable Roblox collection-and-delivery game designed
for a fast first release. Players collect yellow energy cores around a neon arena,
carry them back to the pink reactor, and earn Credits. A two-minute run resets the
score so players have a clear reason to replay and improve.

## Run locally

1. Install [Rojo](https://rojo.space/) and create a new empty Roblox experience.
2. Run `rojo serve` from this repository.
3. In Roblox Studio, install the Rojo Studio plugin and connect to the served project.
4. Enable **Studio Access to API Services** for DataStore testing, then press Play.
5. Replace `BoostProductId = 0` in `src/shared/GameConfig.lua` with a real
   Developer Product ID after creating one in the Creator Dashboard.

The server owns core pickup, delivery, credits, round state, and receipt processing.
DataStore calls fail closed (the run still works, but unsaved credits are not
pretended to be saved). Test purchases in a private published experience; Roblox
does not process Developer Products in Studio.

## Ethical monetization plan

The included product is an optional **2x Credits Boost** for 10 minutes. It does not
block the core loop, remove access to content, or provide an unfair competitive
advantage. A practical first-month target is 100 purchases at 100 Robux, but this is
only a planning target—not a guarantee of income. Reach it through a polished
thumbnail, a short tutorial, daily challenge variations, creator playtests, and
accurate store descriptions. Never use misleading prompts, fake scarcity, or
automated traffic.

Before launch, add a game icon and thumbnail, set the experience age guidelines,
test on mobile, and review the current Roblox Community Standards and monetization
rules.
