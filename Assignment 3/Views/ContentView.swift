import SwiftUI

struct ContentView: View {
    @StateObject var habitViewModel = HabitViewModel()
    @EnvironmentObject var userSettings: UserSettings
    @State private var showingNewHabitView = false

    // ==== Body ====
    var body: some View {
        mainView
            .environmentObject(habitViewModel)
    }

    // ==== Main View ====
    private var mainView: some View {
        NavigationView {
            habitList
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("Habit Tracker")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showingNewHabitView = true }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingNewHabitView) {
                    let newHabit = Habit(name: "")
                    NewHabitView(habit: .constant(newHabit)) { savedHabit in
                        habitViewModel.addHabit(savedHabit)
                    }
                }
        }
    }
    
    // ==== Habit List View ====
    private var habitList: some View {
        List {
            // Section 1 (Todays habits)
            Section(header: Text("Today's Habits")) {
                ForEach(habitViewModel.habits) { habit in
                    NavigationLink(
                      destination: HabitDetailView(
                        habit: habit,
                        onUpdate: { updatedHabit in
                            guard let idx = habitViewModel.habits.firstIndex(where: { $0.id == updatedHabit.id }) else { return }
                            habitViewModel.habits[idx] = updatedHabit
                        }
                      )
                    ) {
                        HStack {
                            Text(habit.name)
                            Spacer()
                            Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(habit.isCompletedToday ? .green : .gray)
                                .onTapGesture {
                                    habitViewModel.toggleCompletion(habit: habit)
                                }
                        }
                    }
                }
                .onDelete(perform: habitViewModel.deleteHabit)
            }

            // Section 2 (Other features)
            // Test
            Section(header: Text("More")) {
                NavigationLink(destination: CalendarView(viewModel: habitViewModel)) {Text("Calendar")}
                NavigationLink(destination: TrackerView(viewModel: habitViewModel)) {Text("Tracker")}
                NavigationLink(destination: SettingsView(userSettings: userSettings)) {Text("Settings")}
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UserSettings())
}
