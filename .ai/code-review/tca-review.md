# TCA Review

Review reducer structure.

Ensure:

State
Action
Reducer
Dependency

are clearly separated.

Check for:

Large reducer files (>300 lines)

If reducer grows too large,
suggest splitting into child features.

Check Action naming.

Prefer:

enum Action

case view
case internal
case delegate
