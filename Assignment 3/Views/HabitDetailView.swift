import SwiftUI

struct HabitDetailView: View {
    // ==== Properties ====
    @State var habit: Habit
    let onUpdate: (Habit) -> Void
    @State private var isEditing = false
    @State private var showingDeleteConfirmation = false
    @EnvironmentObject var viewModel: HabitViewModel
    @Environment(\.dismiss) var dismiss
    
    private var todayLogged: Int {
        let today = Calendar.current.startOfDay(for: Date())
        return viewModel.logs[habit.id]?
            .last(where: { Calendar.current.isDate($0.date, inSameDayAs: today) })?
            .value
        ?? 0
    }

    // ==== Body ====
    var body: some View {
        Form {
            Group {
                    // ==== Habit Viewing Mode ====
                HStack {
                    Text("Habit:")
                    Spacer()
                    Text(habit.name)
                }
                
                HStack {
                    Text("Streak:")
                    Spacer()
                    Text("\(habit.streak) days")
                }
                    
                if habit.type == .numeric {
                    HStack {
                        Text("Milestone:")
                        Spacer()
                        Text("\(todayLogged)/\(habit.goal ?? 0) \(habit.unit ?? "")")
                            .foregroundColor(.secondary)
                    }
                }
    
                HStack {
                    Text("Goal:")
                    Spacer()
                    if let goal = habit.goal, let unit = habit.unit, !unit.isEmpty {
                        Text("\(goal) \(unit)")
                    } else {
                        Text("—")
                        .foregroundColor(.secondary)
                    }
                }
                    
                Toggle("Completed Today", isOn: $habit.isCompletedToday)
                    .onChange(of: habit.isCompletedToday) {
                        onUpdate(habit)
                    }
            }
        }
        .navigationTitle("Habit Details")
        
        // ==== ToolBar ====
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Edit") {
                        isEditing = true
                    }
                    Button("Delete", role: .destructive) {
                        showingDeleteConfirmation = true
                    }
                } label: {
                    Text("...")
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            NewHabitView(habit: $habit, onSave: { updatedHabit in
                onUpdate(updatedHabit)
                isEditing = false
            }, new: false)
        }
        .alert(isPresented: $showingDeleteConfirmation) {
            Alert(
                title: Text("Confirm Delete"),
                message: Text("Are you sure you want to delete \(habit.name)? This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                            if let indexToDelete = viewModel.habits.firstIndex(where: { $0.id == habit.id }) {
                                let indexSetToDelete = IndexSet(integer: indexToDelete)
                                viewModel.deleteHabit(at: indexSetToDelete)
                                dismiss()
                            }
                        },
                secondaryButton: .cancel()
            )
        }
    }
}

#Preview {
    HabitDetailView(
        habit: Habit(name: "Read Book", isCompletedToday: false, streak: 5)
    ) { updatedHabit in
        print("Updated Habit: \(updatedHabit)")
    }
    .environmentObject(HabitViewModel())
}
