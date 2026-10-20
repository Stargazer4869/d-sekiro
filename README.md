# d-sekiro

An original, single-player, 3D boss-combat game. The intended scope is a small series of focused duels, inspired by the readable attacks, deflection, and posture pressure of Sekiro and the boss-only structure of *Kannagi Usagi*. This is not a remake; we will not copy either game's characters, art, audio, levels, or code.

## Current state

Milestone 0 is in progress. A portable Godot 4.7.2 editor, a graybox trial in `prototype/`, and a local Mac development export are available. Unreal setup remains unverified; Godot is the active fallback trial, pending hands-on acceptance. [ROADMAP.md](ROADMAP.md) defines the checkpoints and their exit criteria.

## First deliverable

One original, replayable boss duel on this Mac: one small arena, one player, one boss with about three attacks, movement and lock-on, attack/guard/deflect, health and posture, and victory/death/restart. Aim for a 1–3 minute successful fight and readable feedback that helps the player improve across attempts.

The first delivery excludes additional bosses, exploration, progression, multiplayer, and final art. The key question is whether learning the boss and deflecting its attacks feels satisfying. Dean's hands-on playtest is part of acceptance; automated checks alone cannot establish that.

## Working assumptions

- Start with one player, one boss, and one small arena. Prove the combat loop before expanding content.
- Prototype on Dean's MacBook Pro (M3 Pro, 18 GB unified memory). On 2026-10-19 it reported macOS 27.0.1 and about 68 GiB free; recheck before installing an engine.
- Evaluate Unreal Engine first because its third-person tooling is a good fit. Keep the engine choice provisional until a small on-device performance and workflow test. A lighter engine remains an option.
- Use placeholder art and licensed or self-created assets. Windows packaging and testing become a later checkpoint, not a prerequisite for the first playable duel.
- Keep scope and performance visible: each milestone ends with a playable result, a measurement, and a go / simplify / change-tool decision.

## Getting started

Run `./scripts/play.command` to try the graybox or `./scripts/editor.command` to open it in Godot. Use WASD to move, hold right mouse to orbit, and R to reset. `./scripts/benchmark.command` tests the local exported Mac app at a reported 1920×1080. See [milestone 0 findings and remaining checks](reports/MILESTONE-0.md). Engine selection remains pending until the editing workflow and hands-on trial pass.

The next implementation milestone is movement, camera, lock-on, a dummy, and a repeatable damage source in one arena. Deflection follows only after that gate passes.

## Discussion context

The idea came from asking how to make a game like *Kannagi Usagi* on a Mac. We concluded that this Mac is capable of a small boss-duel prototype; memory and storage headroom, advanced Unreal rendering, and eventual Windows testing are the main constraints. We have not established that *Kannagi Usagi* is open source, so this project must use original or appropriately licensed material.

This file preserves the relevant decisions for future project chats; it is not a copy of the full conversation transcript.
