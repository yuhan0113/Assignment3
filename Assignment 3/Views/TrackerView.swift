import SwiftUI

struct TrackerView: View {
    @ObservedObject var viewModel: HabitViewModel

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("All Habits")) {
                    ForEach(viewModel.habits) { habit in
                        HStack {
                            Text(habit.name)
                            Spacer()
                            Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(habit.isCompletedToday ? .green : .gray)
                                .onTapGesture {
                                    viewModel.toggleCompletion(habit: habit)
                                }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Tracker")
        }
    }
}

struct TrackerView_Previews: PreviewProvider {
    static var previews: some View {
        TrackerView(viewModel: HabitViewModel())
    }
}
