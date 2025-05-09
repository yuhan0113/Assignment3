import SwiftUI

class HabitViewModel: ObservableObject {
    @Published var habits: [Habit] = [] {
        didSet {
            saveHabits()
        }
    }
    
    @Published var logs: [UUID: [HabitLog]] = [:]

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
        let idsToRemove = offsets.map { habits[$0].id }
    }

    func toggleCompletion(habit: Habit) {
        // 1. Find the habit in the array
        guard let idx = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        
        // 2. Flip the "completed today" flag
        let didNowComplete = !habits[idx].isCompletedToday
        habits[idx].isCompletedToday = didNowComplete
        
        // 3. Record (or remove) a log entry for *today* in the logs dict
        let today = Calendar.current.startOfDay(for: Date())
        if didNowComplete {
            // Add a log if we're now marking it complete
            let newLog = HabitLog(date: today, value: nil)
            logs[habit.id, default: []].append(newLog)
        } else {
            // Remove any log dated today if we're un-marking it
            logs[habit.id] = logs[habit.id]?.filter {
                !Calendar.current.isDate($0.date, inSameDayAs: today)
            }
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
