import SwiftUI

struct HabitDetailView: View {
    // ==== Properties ====
    @State var habit: Habit
    let onUpdate: (Habit) -> Void
    @State private var isEditing = false
    @State private var showingDeleteConfirmation = false
    @EnvironmentObject var viewModel: HabitViewModel
    @Environment(\.dismiss) var dismiss

    // ==== Body ====
    var body: some View {
        Form {
            Group {
                // ==== Habit Editing Mode ====
                if isEditing {
                    TextField("Habit Name", text: $habit.name)
                    Button("Save Changes") {
                        isEditing = false
                        onUpdate(habit)
                    }
                    // ==== Habit Viewing Mode ====
                } else {
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
                    
                    Toggle("Completed Today", isOn: $habit.isCompletedToday)
                        .onChange(of: habit.isCompletedToday) {
                            onUpdate(habit)
                        }
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
    let viewModel = HabitViewModel()
    return HabitDetailView(
        habit: Habit(name: "Read Book", isCompletedToday: false, streak: 5)
    ) { updatedHabit in
        print("Updated Habit: \(updatedHabit)")
    }
}
