import SwiftUI

class HabitViewModel: ObservableObject {
    @Published var habits: [Habit] = [] {
        didSet {
            saveHabits()
        }
    }

    init() {
        loadHabits()
        
        // added for testing remove later
        if habits.isEmpty {
            habits = [
                Habit(name: "Test1", isCompletedToday: true, streak: 1),
                Habit(name: "Test2", isCompletedToday: false, streak: 2),
                Habit(name: "Test3", isCompletedToday: true, streak: 3)
            ]
            saveHabits()
        }
    }

    func addHabit(name: String) {
        let newHabit = Habit(name: name)
        habits.append(newHabit)
    }

    func deleteHabit(at offsets: IndexSet) {
        habits.remove(atOffsets: offsets)
    }

    func toggleCompletion(habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index].isCompletedToday.toggle()
            habits[index].streak += 1
        }
    }

    private func fileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("habits.json")
    }

    private func saveHabits() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(habits)
            try data.write(to: fileURL(), options: [.atomicWrite, .completeFileProtection])
        }
        catch {
            print("Error saving habits: \(error)")
        }
    }

    private func loadHabits() {
        do {
            let data = try Data(contentsOf: fileURL())
            let decoder = JSONDecoder()
            habits = try decoder.decode([Habit].self, from: data)
        }
        catch {
            print("Error loading habits: \(error)")
        }
    }
}
