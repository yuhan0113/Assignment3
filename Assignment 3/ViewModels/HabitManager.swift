import Foundation

class HabitManager: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var logs: [UUID: [HabitLog]] = [:]
    // Habit ID -> Logs

    // You can include add/delete habit, and log tracking here if needed
}
