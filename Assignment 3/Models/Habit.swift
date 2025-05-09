import Foundation

struct Habit: Identifiable, Codable {
    let id: UUID
    var name: String
    var isCompletedToday: Bool
    var streak: Int
    var notify: Bool
    var notificationTime: Date?

    init(id: UUID = UUID(), name: String, isCompletedToday: Bool = false, streak: Int = 0, notify:Bool = false, notificationTime: Date? = nil) {
        self.id = id
        self.name = name
        self.isCompletedToday = isCompletedToday
        self.streak = streak
        self.notify = notify
        self.notificationTime = notificationTime
    }
}
