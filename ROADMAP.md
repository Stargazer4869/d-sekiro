# Roadmap and decision gates

The goal is a satisfying boss duel, not a large game built before the core combat is fun. Each gate should be evaluated on the actual Mac before proceeding. Targets are provisional and can be revised after the first performance test.

The first delivery ends at gate 4: one original, replayable duel. Gate 5 is optional future scope. Start with keyboard/mouse controls; keep timing and damage values easy to tune. Each gate needs Dean's hands-on check as well as technical verification.

## 0. Choose a viable toolchain

**Build:** Try a minimal third-person project in Unreal Engine with placeholder assets. Record engine/version, install size, free disk space, editor responsiveness, memory pressure, and standalone-game frame rate at 1080p. Check whether the needed macOS/Xcode versions are compatible before using C++.

**Pass:** Opening, editing, playing, and saving a minimal scene are comfortable on this Mac, with enough free disk space to continue. A graybox scene should have a credible path to 60 FPS in a standalone build.

**Decision:** Continue with Unreal, simplify rendering/settings, or trial a lighter engine. Do not invest in character art before this choice.

### First-session checklist

1. Verify the selected Unreal release's macOS, Xcode, and Metal tooling requirements against this machine. Blueprint projects still need the engine's required Mac tooling. A newer OS alone does not establish compatibility.
2. Check the actual engine/tooling download and installed-size estimates. Include project, shader-cache, and build space; use 25 GiB remaining free as an initial working reserve, not a vendor requirement. If the estimates cannot fit, stop and choose a smaller trial or arrange storage.
3. Use the minimal Third Person template with placeholder assets and modest rendering settings. Avoid optional content packs and advanced rendering features during this trial. Record the exact engine version and settings.
4. Open, play, edit, save, close, and reopen the scene. Run the game in a separate process at 1920×1080; identify whether the result is an editor-launched standalone run or a packaged build. Prove a local development export/package before passing the gate.
5. After shader warmup, move around for 60 seconds. Record average FPS and frame-time spikes (including p95 if available), memory pressure/swap change, cold-open and edit-to-play times, and disk use. Target roughly 60 FPS / 16.7 ms per frame, and record exceptions rather than hiding them in an average.
6. Limit the initial evaluation to one focused trial and one settings adjustment. If setup or iteration is impractical, trial Godot 4 using the same graybox and measurements. Select one engine before building combat.

### Preflight record — 2026-10-19

- Hardware: MacBook Pro, M3 Pro, 18-core GPU, 18 GB unified memory.
- OS/storage: macOS reports 27.0.1; approximately 68 GiB available on the system volume.
- Tooling: selected developer directory is `/Library/Developer/CommandLineTools`; no full Xcode or Epic Games Launcher in `/Applications`, and no `/Users/Shared/Epic Games` directory found. These are standard-location checks, not an exhaustive installation search.
- Epic's published Mac requirements list 16 GB minimum and 32 GB recommended memory. This machine exceeds the minimum but is below the recommendation. Verify the chosen release's exact SDK compatibility before installation: [Epic requirements](https://dev.epicgames.com/documentation/unreal-engine/macos-development-requirements-for-unreal-engine).
- Fallback: the standard [Godot 4 macOS editor](https://godotengine.org/download/macos/) supports Apple Silicon; use GDScript for a smaller toolchain trial if needed.
- Playable check: not run; no engine project exists. FPS, frame times, memory pressure under engine load, install size, and iteration times are unmeasured.
- Initial preflight decision: remain at gate 0. Unreal installation budget and compatibility were unresolved.

### Trial update — 2026-10-19

Godot 4.7.2 is the active fallback trial after the Unreal/Xcode compatibility check remained unresolved on macOS 27.0.1. A minimal third-person graybox imports and runs; a local ARM64 Mac development export succeeds and renders correctly. Engine selection and gate acceptance remain pending Dean's hands-on check, full editor save/reopen verification, and reliable iteration/memory measurements. See [the trial report](reports/MILESTONE-0.md) for performance results, limitations, and launch commands. No combat systems or later gate were started.

## 1. First controllable duel space

**Build:** One graybox arena, third-person movement, camera, lock-on, one target dummy, a basic attack, visible health, and a repeatable damage source (for example, a marked hazard). Include death and restart; the dummy does not yet need combat AI.

**Pass:** A player can move, lock on, land attacks, take damage, die, and restart reliably. Measure frame rate again; investigate serious stutter before adding systems.

## 2. Deflection and posture loop

**Build:** One telegraphed enemy attack, a short deflection window, guard/failed-deflection outcomes, posture buildup, stagger, and a punish opportunity. Add simple visual or audio feedback that distinguishes each outcome.

**Pass:** In repeated playtests, the player can tell *why* a deflection succeeded or failed. The full attack-to-deflect-to-stagger loop works without animation-dependent timing bugs.

Use explicit windup, active, and recovery states with tunable timing. Check early guard, successful deflection, late input, repeated button presses, and one-hit-per-swing behavior. Compare timing at 30 and 60 FPS so game rules do not depend on rendered frame counts.

## 3. One complete boss

**Build:** A boss with roughly three distinct attacks, readable tells, recovery windows, health and posture rules, victory/death/restart flow, and a short fight (initial target: 1–3 minutes).

**Pass:** The fight can be completed repeatedly without softlocks; players can learn the patterns rather than rely on random outcomes. Capture performance and playtest notes, then decide whether the core is fun enough to polish.

Run at least five consecutive attempts covering both death/restart and victory/restart. Ask Dean whether tells are readable, failures understandable, and another attempt appealing. If the loop is not satisfying, revise this gate before adding art or attacks.

## 4. Polish the vertical slice

**Build:** Replace selected placeholders with original/licensed art, improve animations, hit feedback, camera, sound, UI, and accessibility. Keep the encounter count at one until the first duel feels good.

**Pass:** The fight remains readable and responsive on the target Mac, and its standalone build stays near the chosen performance target. Record any compromises.

## 5. Expand only after the slice succeeds

Consider additional bosses, progression, controller support, and a Windows build. Test Windows builds on actual Windows hardware before treating that platform as supported. Reassess storage, memory, and engine choice before increasing scope.

## Operating rule

At each gate, record: what works, measured performance, the biggest remaining problem, and the explicit decision to proceed, simplify, or change direction. A failed gate is a reason to adjust scope or tools, not to silently add more features.

Include the engine version, scene/build, resolution/render settings, test duration, playable-check result, and known limitations with each measurement. Label missing measurements as unmeasured; do not treat a headless test or editor FPS as proof of standalone playability.
