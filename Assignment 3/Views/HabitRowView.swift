import SwiftUI

struct HabitRowView: View {
    let habit: Habit
    @ObservedObject var viewModel: HabitViewModel
    @State private var numericInput: String = ""

    var body: some View {
        HStack {
            Text(habit.name)
            Spacer()

            if habit.type == .boolean {
                Image(systemName: habit.isCompletedToday
                      ? "checkmark.circle.fill"
                      : "circle")
                    .foregroundColor(habit.isCompletedToday ? .green : .gray)
                    .onTapGesture {
                        viewModel.toggleCompletion(habit: habit)
                    }

            } else {
                HStack(spacing: 8) {
                    // 1) Input box, placeholder shows the unit
                    TextField("Enter \(habit.unit ?? "")", text: $numericInput)
                        .keyboardType(.numberPad)
                        .frame(width: 60)
                        .multilineTextAlignment(.trailing)

                    //Unit label
                    if let unit = habit.unit {
                        Text(unit)
                            .foregroundColor(.secondary)
                    }

                    //Save button
                    Button("Save") {
                        if let amt = Int(numericInput) {
                            viewModel.logValue(for: habit, amount: amt)
                            numericInput = ""
                        }
                    }
                    .disabled(numericInput.isEmpty)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct HabitRowView_Previews: PreviewProvider {
    static var previews: some View {
        HabitRowView(
            habit: Habit(name: "Test", type: .numeric),
            viewModel: HabitViewModel()
        )
    }
}
