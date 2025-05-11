import SwiftUI

// RENAME THE VIEW AFTER EVERYTHING IS DONE

struct NewHabitView: View {
    @Binding var habit: Habit
    let onSave: (Habit) -> Void
    @Environment(\.dismiss) var dismiss
    @State private var habitName: String
    @State private var type: TrackingType
    @State private var unitText: String
    @State private var goalText: String
    @State private var notify: Bool
    @State private var notificationTime: Date
    let new: Bool
    @EnvironmentObject var habitViewModel: HabitViewModel

    init(habit: Binding<Habit>, onSave: @escaping (Habit) -> Void, new: Bool) {
        self._habit = habit
        self.onSave = onSave
        self.new = new
        _habitName = State(initialValue: habit.wrappedValue.name)
        _type = State(initialValue: habit.wrappedValue.type)
        _unitText = State(initialValue: habit.wrappedValue.unit ?? "")
        _goalText = State(initialValue: habit.wrappedValue.goal.map(String.init) ?? "")
        _notify = State(initialValue: habit.wrappedValue.notify)
        _notificationTime = State(initialValue: habit.wrappedValue.notificationTime ?? Date())
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Habit Name", text: $habitName)
                Toggle("Notify", isOn: $notify)
                if notify {
                    DatePicker("Notification Time", selection: $notificationTime, displayedComponents: .hourAndMinute)
                }
                if type == .numeric {
                    TextField("Unit (e.g. km, ml)", text: $unitText)
                      .padding(.vertical, 4)

                    TextField("Goal (\(unitText))", text: $goalText)
                      .keyboardType(.numberPad)
                      .padding(.vertical, 4)
                  }
                
                Picker("Type", selection: $type) {
                    Text("Yes/No").tag(TrackingType.boolean)
                    Text("Numeric").tag(TrackingType.numeric)
                  }
                  .pickerStyle(SegmentedPickerStyle())
                  .padding(.vertical)
            }
            .navigationTitle(new ? "Add New Habit" : "Edit Habit")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let goalValue = Int(goalText)
                        let savedHabit = Habit(id: habit.id, name: habitName, isCompletedToday: habit.isCompletedToday, streak: habit.streak, notify: notify, notificationTime: notificationTime, type: type, unit: unitText.isEmpty ? nil : unitText, goal: goalValue)
                        onSave(savedHabit)
                        habit.notify = notify;
                        habit.notificationTime = notificationTime
                        if notify {
                            habitViewModel.scheduleNotification(for: savedHabit)
                        }
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
    NewHabitView(habit: $dummyHabit, onSave: { savedHabit in
        print("Saved habit: \(savedHabit)")
    }, new: true)
}
