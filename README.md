# 📱 Habit Tracker App

A simple and focused iOS app built using **SwiftUI** that helps users track and build daily habits with reminders and calendar features.

## 🔗 Project Repository
https://github.com/yuhan0113/Assignment3

## 🧠 Features

- ✅ Add and customise habits (either boolean [yes/no] or numeric [measurable])
- ✏️ Edit habits inline with goal setting and unit (e.g. “3 km of running”, “5 pints of beer”)
- 📆 View habit completion across days in a calendar
- 🔔 Enable daily reminders with time selection
- 📈 Log numeric values directly in a tracker view
- 🔁 Auto-streak tracking for completed habits
- 💾 Persistent storage using `UserDefaults` and `Codable`

---

## 🧱 Architecture Overview

| File | Responsibility |
|------|----------------|
| `ContentView.swift` | Homepage, shows today’s habit list |
| `HabitDetailView.swift` | View & edit habit properties, see goal/milestone |
| `NewHabitView.swift` | Form to add a new habit (with unit/goal if numeric) |
| `CalendarView.swift` | Monthly log view showing completion status |
| `TrackerView.swift` | Log numeric input per habit |
| `HabitRowView.swift` | UI for boolean toggle or numeric entry |
| `SettingsView.swift` | User profile (name), reminder settings |
| `HabitViewModel.swift` | Handles habit logic, logging, toggling |
| `Habit.swift` | Model for habit details, type, goals, etc. |
| `HabitLog.swift` | Struct to track daily logs per habit |
| `UserSettings.swift` | Stores user preferences like display name and reminder time |

---

## 🧪 Technology We Used

- **SwiftUI** (iOS 17+)
- **MVVM-lite** design pattern
- Property wrappers: `@State`, `@Binding`, `@StateObject`, `@ObservedObject`
- `Codable` for data encoding/decoding
- `UserDefaults` for local persistence
- `#Preview` blocks for SwiftUI live previews
- Custom calendar + logging logic

---

## 🧑‍💻 Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/yuhan0113/Assignment3.git
