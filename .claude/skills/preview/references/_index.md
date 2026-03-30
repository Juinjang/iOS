# Preview Optimization Quick Reference Index

## Overview
Patterns and rules for building fast, deterministic Xcode Previews
in a TCA + TMA (Tuist) modular iOS project.

## Golden Rule
**Preview = leaf view + fixed state + mock dependency + deterministic rendering**

## Reference Files

| File | Topic | Key Concepts |
|------|-------|--------------|
| `preview-principles.md` | Core principles | Never preview root views, no effects, no global state |
| `preview-state-patterns.md` | State patterns | `static let` on Feature.State, pre-populated variants |
| `preview-dependency-mock.md` | Mock dependencies | `.mock` / `.preview` statics, `withDependencies` closure |
| `preview-effect-guard.md` | Effect guards | `isPreview` dependency, reducer-level guard |
| `preview-tma-structure.md` | TMA module rules | Example scheme, file location, dependency chain |

## Quick Checklist
1. Target a **leaf view**, not a root/coordinator
2. Provide **fixed state** via `static let` on `Feature.State`
3. Inject **mock dependencies** via `withDependencies`
4. Guard effects with **isPreview** in the reducer
5. Use **Example scheme** (`{Feature}Example`) for Preview in TMA modules
6. Split large view bodies into **@ViewBuilder computed properties**
