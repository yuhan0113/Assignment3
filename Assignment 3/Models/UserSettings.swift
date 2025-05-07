import Foundation

class UserSettings: ObservableObject {
    @Published var displayName: String {
        didSet { save() }
    }

    @Published var dailyReminderEnabled: Bool {
        didSet { save() }
    }

    @Published var reminderTime: Date {
        didSet { save() }
    }

    init() {
        self.displayName = UserDefaults.standard.string(forKey: "displayName") ?? "User"
        self.dailyReminderEnabled = UserDefaults.standard.bool(forKey: "dailyReminderEnabled")
        self.reminderTime = UserDefaults.standard.object(forKey: "reminderTime") as? Date ?? Date()
    }

    func save() {
        UserDefaults.standard.set(displayName, forKey: "displayName")
        UserDefaults.standard.set(dailyReminderEnabled, forKey: "dailyReminderEnabled")
        UserDefaults.standard.set(reminderTime, forKey: "reminderTime")
    }
}
