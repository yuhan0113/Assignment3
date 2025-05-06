import Foundation

struct Habit: Identifiable, Codable {
    let id: UUID
    var name: String
    var isCompletedToday: Bool
    var streak: Int

    init(id: UUID = UUID(), name: String, isCompletedToday: Bool = false, streak: Int = 0) {
        self.id = id
        self.name = name
        self.isCompletedToday = isCompletedToday
        self.streak = streak
    }
}
