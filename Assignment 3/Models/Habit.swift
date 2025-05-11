import Foundation

enum TrackingType: String, Codable {
  case boolean, numeric
}

struct Habit: Identifiable, Codable {
    let id: UUID
    var name: String
    var type: TrackingType
    var isCompletedToday: Bool
    var streak: Int
    var notify: Bool
    var notificationTime: Date?
    var unit: String?
    var goal: Int?

    init(id: UUID = UUID(), name: String, isCompletedToday: Bool = false, streak: Int = 0, notify:Bool = false, notificationTime: Date? = nil, type: TrackingType = .boolean, unit: String? = nil, goal: Int? = nil) {
        self.id = id
        self.name = name
        self.isCompletedToday = isCompletedToday
        self.streak = streak
        self.notify = notify
        self.notificationTime = notificationTime
        self.type = type
        self.unit = unit
        self.goal = goal
    }
    var isNumeric: Bool { type == .numeric }
}
