import SwiftUI

// RENAME THE VIEW AFTER EVERYTHING IS DONE

struct NewHabitView: View {
    @Binding var habit: Habit
    let onSave: (Habit) -> Void
    @Environment(\.dismiss) var dismiss
    @State private var habitName: String

    init(habit: Binding<Habit>, onSave: @escaping (Habit) -> Void) {
        self._habit = habit
        self.onSave = onSave
        _habitName = State(initialValue: habit.wrappedValue.name)
    }
    var body: some View {
        NavigationView {
            Form {
                TextField("Habit Name", text: $habitName)
            }
            .navigationTitle(habit.id == UUID() ? "Add New Habit" : "Edit Habit")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let savedHabit = Habit(id: habit.id, name: habitName, isCompletedToday: habit.isCompletedToday, streak: habit.streak)
                        onSave(savedHabit)
                        dismiss()
                    }
                    .disabled(habitName.isEmpty)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var dummyHabit = Habit(name: "Test Habit")
    NewHabitView(habit: $dummyHabit) { savedHabit in
        print("Saved habit: \(savedHabit)")
    }
}
