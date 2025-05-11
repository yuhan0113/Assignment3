import SwiftUI

struct TrackerView: View {
    @ObservedObject var viewModel: HabitViewModel

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Log Progress")) {
                    ForEach(viewModel.habits) { habit in
                        HabitRowView(habit: habit, viewModel: viewModel)
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
