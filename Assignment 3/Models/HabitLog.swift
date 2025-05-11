import Foundation

struct HabitLog: Identifiable, Codable {
    let id: UUID
    let date: Date
    var value: Int?
    let habitID: UUID
    let completed: Bool

    init(id: UUID = UUID(), date: Date = Date(), value: Int? = nil, habitID: UUID, completed: Bool = false) {
        self.id = id
        self.date = date
        self.value = value
        self.habitID = habitID
        self.completed = completed
    }
}
