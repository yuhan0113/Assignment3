import SwiftUI

struct ContentView: View {
    @StateObject var habitViewModel = HabitViewModel()
    @State private var showingNewHabitView = false

    // ==== Body ====
    var body: some View {
        mainView
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
                        habitViewModel.addHabit(name: savedHabit.name)
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
                                //original habit
                                guard let idx = habitViewModel.habits.firstIndex(where: { $0.id == updatedHabit.id }) else { return }
                                let old = habitViewModel.habits[idx]

                                // if completion toggled, record or un-record a log
                                if updatedHabit.isCompletedToday != old.isCompletedToday {
                                    habitViewModel.toggleCompletion(habit: old)
                                }

                                // if name changed, update it
                                if updatedHabit.name != old.name {
                                    habitViewModel.habits[idx].name = updatedHabit.name
                                }
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
            Section(header: Text("More")) {
                NavigationLink(destination: CalendarView(viewModel: habitViewModel)) {Text("Calendar")}
                NavigationLink(destination: TrackerView(viewModel: habitViewModel)) {Text("Tracker")}
                NavigationLink("Settings", destination: SettingsView())
            }
        }
    }
}

#Preview {
    ContentView()
}
