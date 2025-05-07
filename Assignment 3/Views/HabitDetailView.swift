import SwiftUI

struct HabitDetailView: View {
    @State var habit: Habit
    let onUpdate: (Habit) -> Void
    @State private var isEditing = false

    var body: some View {
        Form {
            if isEditing {
                TextField("Habit Name", text: $habit.name)
                Button("Save Changes") {
                    isEditing = false
                    onUpdate(habit)
                }
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
        .navigationTitle("Habit Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Cancel" : "Edit") {
                    isEditing.toggle()
                }
            }
        }
    }
}

#Preview {
    HabitDetailView(habit: Habit(name: "Read Book", isCompletedToday: false, streak: 5)) { updatedHabit in
        print("Updated Habit: \(updatedHabit)")
    }
}
