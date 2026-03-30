---
name: preview-optimization
description: Xcode Preview optimization patterns for TCA + TMA modular iOS projects
---

# Preview Optimization Skill

## Overview
Expert knowledge for building fast, reliable, and deterministic Xcode Previews
in a TCA + TMA (Tuist Modular Architecture) project.
Covers state setup, dependency mocking, effect guarding, and module-level Preview configuration.

## When to Use
- Creating or fixing Xcode Previews for TCA feature views
- Debugging slow or crashing Previews
- Setting up Preview in a TMA feature module (Example scheme)
- Mocking dependencies for isolated Preview rendering
- Optimizing SwiftUI view body for faster Preview compilation
- Splitting large views to improve Preview responsiveness

## References
All reference files are located in `./references/` directory:

- `_index.md` - Quick reference index
- `preview-principles.md` - Core principles and rules
- `preview-state-patterns.md` - Preview State patterns (static let extensions)
- `preview-dependency-mock.md` - Mock dependency patterns for Preview stores
- `preview-effect-guard.md` - Effect guard patterns using isPreview
- `preview-tma-structure.md` - TMA module-specific Preview rules and file layout

## Related Skills
- `tca` - The Composable Architecture patterns
- `tma` - Tuist Modular Architecture structure
- `design-system` - Reusable UI components used in Previews
