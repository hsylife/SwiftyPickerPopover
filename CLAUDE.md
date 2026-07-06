# CLAUDE.md — SwiftyPickerPopover

Guidance for AI agents (Claude Code, etc.) working in this repository.
Keep `AGENTS.md` identical to this file if both exist.

## What this project is

A UIKit library that shows a popover containing a picker. Four popover types,
each implemented as a pair: a builder/state class (`XxxPopover`, subclass of
`AbstractPopover`) and a storyboard-backed view controller
(`XxxPopoverViewController`, subclass of `AbstractPickerPopoverViewController`).

- Library source: `SwiftyPickerPopover/` (source of truth)
- Demo app: `Demo/`
- Distribution: CocoaPods (`SwiftyPickerPopover.podspec`), Carthage. SPM planned.
- Public API style: fluent builder (`setXxx(...) -> Self`), then `appear(...)`.

## Build & verify

```sh
# Library (framework)
xcodebuild -project SwiftyPickerPopover.xcodeproj \
  -scheme SwiftyPickerPopover -destination 'generic/platform=iOS Simulator' build

# Run tests (once a test target exists)
xcodebuild -project SwiftyPickerPopover.xcodeproj \
  -scheme SwiftyPickerPopover -destination 'platform=iOS Simulator,name=iPhone 16' test
```

Every change must leave the library AND the Demo app building. If you fix a
bug, add a failing-first regression test in the same PR.

## Hard rules

1. **Never change or remove a `public`/`open` API signature.** Additive changes
   and `@available(*, deprecated, ...)` annotations are allowed. Breaking
   changes are decided by a human and land only on a major-version branch.
2. **Duplication awareness.** Button, font, and style logic is duplicated
   across all four popover classes and all four view controllers. Before
   editing any of it, `grep` for the sibling implementations
   (`setButton`, `ButtonParameterType`, `refrectPopoverProperties`) and apply
   the change to every affected file, or explicitly state why one site differs.
3. **Do not edit `.storyboard` / `.xib` files** unless the task explicitly
   requires it; storyboard diffs are unreviewable. If you must, attach
   before/after snapshot evidence.
4. **No new force unwraps (`!`), no KVC access to private UIKit state, no
   private API.** Prefer the existing `[safe:]` subscript for array access
   indexed by picker rows.
5. **Resource loading:** strings/storyboards must resolve against the
   library's own bundle (`Bundle(for: AbstractPopover.self)`, or
   `Bundle.module` under SPM) — never assume `Bundle.main`.
6. **Keep invariants in sync:** `choices` and `images` in
   `StringPickerPopover` must always have equal length once both are set;
   `setClearButton` mutates `choices` — mirror any such mutation in `images`.
7. **One concern per PR, roughly ≤300 changed lines.** Do not mix refactoring
   with behavior changes. Update `CHANGELOG.md` in every user-visible PR.
8. **Localization:** user-facing strings go through `String.localized` with
   entries in `Base.lproj` and `ja.lproj`.

## Known landmines

- `AbstractPopover.appear(barButtonItem:)` uses `value(forKey: "view")` — do
  not replicate this pattern.
- `refrectPopoverProperties()` is a typo but is effectively API — do not
  rename without a deprecation path.
- `disappear()` dismisses whatever `baseViewController` is presenting; be
  careful when touching dismissal logic.
- DatePicker-based popovers require `preferredDatePickerStyle = .wheels` on
  iOS 13.4+; the compact style breaks the popover layout.

## Style

- Follow the existing code style (Swift API Design Guidelines where the two
  conflict is a judgment call — prefer consistency within a file).
- Doc comments (`///`) on all public API, matching the existing format.
- No new third-party dependencies without human sign-off (the library is
  intentionally dependency-free).
