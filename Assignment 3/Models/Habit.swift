import Foundation

struct Habit: Identifiable {
    let id = UUID()
    var name: String
    var isCompletedToday: Bool
}
