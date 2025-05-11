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
                Habit(name: "Test1", isCompletedToday: false, streak: 1),
                Habit(name: "Test2", isCompletedToday: false, streak: 2),
                Habit(name: "Test3", isCompletedToday: false, streak: 3)
            ]
            saveHabits()
        }
    }

    func addHabit(_ habit: Habit) {
      habits.append(habit)
      saveHabits()
    }

    func deleteHabit(at offsets: IndexSet) {
        habits.remove(atOffsets: offsets)
    }
    
    func logValue(for habit: Habit, amount: Int) {
        let today = Calendar.current.startOfDay(for: Date())
        let meetsGoal = (amount >= (habit.goal ?? Int.max)) // Compare input with goal

        // Record the log
        let entry = HabitLog(
            date: today,
            value: amount,
            habitID: habit.id,
            completed: meetsGoal
        )
        logs[habit.id, default: []].append(entry)

        // Only tick today if user meet the goal
        if let idx = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[idx].isCompletedToday = meetsGoal
        }
    }

    func toggleCompletion(habit: Habit) {
        guard let idx = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        
        let didNowComplete = !habits[idx].isCompletedToday
        habits[idx].isCompletedToday = didNowComplete
        
        let today = Calendar.current.startOfDay(for: Date())
        if didNowComplete {
            // Add a log if they are marking it complete
            let newLog = HabitLog(date: today, value: nil, habitID: habit.id, completed: true)
            logs[habit.id, default: []].append(newLog)
        } else {
            // Remove any log dated today if user are un-marking it
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
