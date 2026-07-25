# MacBee — Architecture

MVVM + SwiftUI. The main app and the widget share one data layer; each has its own view /
view-model surface. See [PROJECT_CONTEXT.md](PROJECT_CONTEXT.md) for what/why.

## Layers

```
        ┌─────────────────────┐        ┌──────────────────────┐
        │      Main App        │        │   Widget Extension   │
        │  (SwiftUI window)    │        │      (WidgetKit)     │
        ├─────────────────────┤        ├──────────────────────┤
  View  │  WordView            │        │  WordWidgetView      │
        │  WordListView        │        │  (entry -> SwiftUI)  │
        ├─────────────────────┤        ├──────────────────────┤
 VM /   │  WordViewModel       │        │  TimelineProvider    │
 driver │  (@Observable)       │        │  (builds entries)    │
        └──────────┬──────────┘        └──────────┬───────────┘
                   │                               │
                   └───────────────┬───────────────┘
                                   ▼
                    ┌───────────────────────────────┐
              Model │  WordProvider (word(for:Date)) │
                    │  Word (id, term, definition…)  │
                    │  words.json  (bundled)         │
                    └───────────────────────────────┘
```

## Roles

**Model**
- `Word` — a plain `struct` (`Codable`, `Identifiable`): term, definition, part of speech, example.
- `WordProvider` — loads `words.json` once and exposes `word(for date: Date) -> Word`.
  The mapping is pure date math (e.g. days-since-epoch modulo count), so it's deterministic:
  the app and the widget compute the *same* word for a given day with no shared mutable state.

**ViewModel**
- `WordViewModel` — `@Observable` (or `ObservableObject`). Holds `today: Word` and any
  list/browse state, calls `WordProvider`. No SwiftUI imports beyond `Observation`; no
  view types. This is the unit-testable seam.
- The widget does **not** reuse `WordViewModel`. Its "view model" is the WidgetKit
  `TimelineProvider`, which asks `WordProvider` for entries. Same model, different driver —
  because widgets are timeline-driven, not user-event-driven.

**View**
- App: `WordView` (today), `WordListView` (history) — dumb, bind to the view model.
- Widget: `WordWidgetView` renders a single `TimelineEntry`.

## Data flow

App (interactive):
`View` → `WordViewModel.load()` → `WordProvider.word(for:)` → view model publishes → `View` re-renders.

Widget (timeline):
`TimelineProvider.timeline()` → builds one `TimelineEntry` per upcoming day (or one entry +
a refresh policy of `.after(nextMidnight)`) → WidgetKit renders `WordWidgetView` and wakes it
at midnight for the next word.

## Sharing between app & widget
- Code: put `Word`, `WordProvider`, and `words.json` in a **shared target / framework** (or
  add them to both targets' membership) so both compile against one source of truth.
- Runtime state (if any is ever needed — e.g. "favorited" words): an **App Group**
  (`group.com.hariom.swift.MacBee`) via `UserDefaults(suiteName:)`. For pure word-of-the-day,
  no shared runtime state is needed because selection is date-derived.

## Refresh
Widget requests reload at the next local midnight (`Calendar.nextDate` → `Timeline(...,
policy: .after(midnight))`). No timers, no background fetch.

## Conventions
- View models never import view types; views never do data loading.
- `WordProvider` is the only thing that touches the bundle / disk — inject it into view
  models and the timeline provider so both can be tested with a stub list.
- Keep `words.json` the single source of word data; don't duplicate copy in code.

## Testing seam
`WordProvider.word(for:)` and `WordViewModel` are pure over an injected word list — unit-test
date→word mapping (boundaries: day rollover, list wrap-around) without WidgetKit or SwiftUI.

## Suggested layout
```
MacBee/
  App/            MacBeeApp.swift, WordView.swift, WordListView.swift, WordViewModel.swift
  Shared/         Word.swift, WordProvider.swift, words.json      (member of both targets)
  Widget/         WordWidget.swift, WordTimelineProvider.swift, WordWidgetView.swift
```
