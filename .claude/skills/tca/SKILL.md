---
name: tca-expert
description: The Composable Architecture (TCA) expert skill for iOS development
version: 1.24.1+
---

# TCA Expert Skill

## Overview
Expert knowledge of The Composable Architecture (TCA) by Point-Free.
Target version: **1.24.1+** with `@Reducer` macro, `@ObservableState`, and modern navigation APIs.

## When to Use
- Building new features with TCA pattern
- Implementing navigation (StackState, tree-based)
- Composing reducers (Scope, ifLet, forEach)
- Managing dependencies via `@Dependency`
- Writing tests for TCA reducers
- Migrating from older TCA versions

## References
All reference files are located in `./references/` directory:

- `_index.md` - Quick reference index
- `reducer-basics.md` - @Reducer macro, State, Action, body
- `navigation.md` - StackState/StackAction, tree-based navigation
- `interface-navigation.md` - Interface/Implementation split pattern for modular navigation
- `dependencies.md` - @Dependency, DependencyKey, DependencyClient
- `effects.md` - Effect, async/await, cancellation
- `testing.md` - TestStore, exhaustive/non-exhaustive testing
- `bindings.md` - @BindableState, BindableAction
- `shared-state.md` - @Shared, persistence
- `composition.md` - Scope, ifLet, forEach, reducer composition
- `naming-conventions.md` - HTTP Method → Domain 네이밍 규칙 (fetch/create/update/remove 등)
