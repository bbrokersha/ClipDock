# Verification — 0.3.0 candidate

Environment: macOS 27.0.1, Xcode macOS 27 SDK, Apple Silicon development host.

## Automated

- Existing 25 tests: core history/settings/persistence and native clipboard
  integration passed during this change.
- Action round-trip/edit/delete, corrupt/future data preservation and duplicate ID
  rejection tested in temporary directories.
- Script validation checks format, bounded reads, NUL rejection and paths with spaces.
- Script execution uses a harmless fixture in a temporary directory; no user scripts run.
- Release builds target both arm64 and x86_64; ad-hoc bundle integrity is verified.

## UI observed on development host

- App launched outside Xcode; Settings titlebar covers the full width.
- Actions editor and asynchronous file picker opened successfully.
- Created a temporary Calculator launch action, saved it, ran it (success shown),
  then deleted the temporary definition.

## UNVERIFIED_MANUAL — release gates

- Editing existing actions, shortcut recording and conflicts.
- Confirm/cancel scripts through the GUI; ON/OFF cycling and exit-status display.
- App launch/quit including unsaved documents and permission denial.
- Physical F1–F12 behavior; manual original-setting restoration.
- Game Mode ON/OFF with LinearMouse absent, already running and launched by ClipDock.
- Crash/restart recovery warning and manual cleanup of external effects.
- Accessibility-approved paste and destination-dependent drag acceptance.
- Clean-machine install, macOS 14, Intel hardware and Gatekeeper behavior.
- GitHub Actions and release downloads should be checked for each tag.

Automated success is not proof of these manual behaviors. This candidate must not
be represented as a fully verified public release until the gates are completed.
No screenshots are included because no new, synthetic-data UI capture was verified.

## 0.3.1 startup repair

The affected host had no ClipDock installed in /Applications or ~/Applications
and no running ClipDock process. Both panel and Game Mode shortcuts remained
in the saved settings. Global shortcuts require a running process.

Login settings now show live Service Management status, distinguish pending
approval, refresh when the app becomes active, and prevent registration from
transient locations. Identical hotkey registrations are idempotent.
Added regression checks for installed paths and both shortcuts across reloads.
A real logout/login is still UNVERIFIED_MANUAL; registration alone is not proof
that macOS launches the app on the next login.

On November 19, the installed copy reported launch at login enabled. macOS's
background item database also reported /Applications/ClipDock.app enabled and
allowed. The saved panel shortcut opened ClipDock from Finder. A real subsequent
login remains UNVERIFIED_MANUAL. The owner subsequently confirmed on November 19
that pressing Shift-Command-Left on the physical keyboard opens the Game Mode
confirmation dialog. Hotkey invocation is manually verified; this does not verify
function-key behavior or the complete Game Mode ON/OFF cycle.

Shortcut labels now normalize arrow and number keys without modifying the saved
key codes or modifier flags.
