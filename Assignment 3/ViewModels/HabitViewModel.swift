import SwiftUI

class HabitViewModel: ObservableObject {
    @Published var habits: [Habit] = []

    func addHabit(name: String) {
        let newHabit = Habit(name: name)
        habits.append(newHabit)
    }

    func deleteHabit(at offsets: IndexSet) {
        habits.remove(atOffsets: offsets)
    }

    func updateHabit(habit: Habit) {

    }

    func toggleCompletion(habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index].isCompletedToday.toggle()
        }
    }
}
