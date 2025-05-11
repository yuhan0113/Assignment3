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
        setupDailyResetTimer()
        scheduleAllNotifications()
        
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
        for index in offsets {
            let habitToDelete = habits[index]
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [habitToDelete.id.uuidString])
        }
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
    
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Error : \(error)")
                return
            }
            if granted {
                DispatchQueue.main.async {
                    self.scheduleAllNotifications()
                }
            }
        }
    }
    
    func scheduleNotification(for habit: Habit) {
        guard habit.notify, let notificationTime = habit.notificationTime, !habit.isCompletedToday else {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [habit.id.uuidString])
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "Habit Reminder"
        content.body = "You haven't completed \(habit.name) today!"
        content.sound = .default

        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: notificationTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: habit.id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification for \(habit.name): \(error)")
            } else {
                print("Notification scheduled for \(habit.name) at \(notificationTime)")
            }
        }
    }
    
    func scheduleAllNotifications() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    for habit in self.habits {
                        self.scheduleNotification(for: habit)
                    }
                }
            }
        }
    }
    
    func setupDailyResetTimer() {
        let calendar = Calendar.current
        
        guard let nextDay = calendar.date(byAdding: .day, value: 1, to: Date()) else {
            print("Can't calculate next day")
            return
        }
        let startOfNextDay = calendar.startOfDay(for: nextDay)
        let timeInterval = startOfNextDay.timeIntervalSinceNow
        
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            for index in habits.indices {
                habits[index].isCompletedToday = false
            }
            saveHabits()
            self.setupDailyResetTimer()
        }
    }
}
