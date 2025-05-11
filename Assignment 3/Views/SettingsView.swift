import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        Form {
            // ==== Display Name ====
            Section(header: Text("Profile")) {
                TextField("Your name", text: $userSettings.displayName)
            }

            // ==== Daily Reminder ====
            Section(header: Text("Reminders")) {
                Toggle("Daily Reminder", isOn: $userSettings.dailyReminderEnabled)
                    .onChange(of: userSettings.dailyReminderEnabled) {
                        if userSettings.dailyReminderEnabled {
                            var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                            components.hour = 18
                            components.minute = 0
                            if let defaultTime = Calendar.current.date(from: components) {
                                userSettings.reminderTime = defaultTime
                            }
                        }
                    }

                if userSettings.dailyReminderEnabled {
                    DatePicker("Reminder Time", selection: $userSettings.reminderTime, displayedComponents: .hourAndMinute)
                }
            }

            // ==== App Info ====
            Section(header: Text("About")) {
                Text("Habit Tracker v1.0")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
        .environmentObject(UserSettings())
}
