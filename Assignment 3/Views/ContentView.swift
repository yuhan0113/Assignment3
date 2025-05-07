import SwiftUI

struct ContentView: View {
    @StateObject var habitViewModel = HabitViewModel()
    @State private var showingNewHabitView = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Today's Habits")) {
                    ForEach(habitViewModel.habits) { habit in
                        NavigationLink(destination: HabitDetailView(habit: habit, onUpdate: { updatedHabit in
                            if let index = habitViewModel.habits.firstIndex(where: { $0.id == updatedHabit.id }) {
                                habitViewModel.habits[index] = updatedHabit
                            }
                        })) {
                            HStack {
                                Text(habit.name)
                                Spacer()
                                Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(habit.isCompletedToday ? .systemGreen : .gray)
                                    .onTapGesture {
                                        habitViewModel.toggleCompletion(habit: habit)
                                    }
                            }
                        }
                    }
                    .onDelete(perform: habitViewModel.deleteHabit)
                }

                Section(header: Text("More")) {
                    NavigationLink("Calendar", destination: CalendarView())
                    NavigationLink("Tracker", destination: TrackerView())
                    NavigationLink("Settings", destination: SettingsView())
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Habit Tracker")
            .toolbar {
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
}

#Preview {
    ContentView()
}
