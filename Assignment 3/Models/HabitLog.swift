import Foundation

struct HabitLog: Identifiable, Codable {
    let id: UUID
    let date: Date
    var value: Int?

    init(id: UUID = UUID(), date: Date = Date(), value: Int? = nil) {
        self.id = id
        self.date = date
        self.value = value
    }
}
