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
                    // "+" button to add a new habit
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showingNewHabitView = true
                        }) {
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
                                if let index = habitViewModel.habits.firstIndex(where: { $0.id == updatedHabit.id }) {
                                    habitViewModel.habits[index] = updatedHabit
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
                NavigationLink("Calendar", destination: CalendarView())
                NavigationLink("Tracker", destination: TrackerView())
                NavigationLink("Settings", destination: SettingsView())
            }
        }
    }
}

#Preview {
    ContentView()
}
