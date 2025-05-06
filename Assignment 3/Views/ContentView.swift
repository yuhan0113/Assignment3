import SwiftUI

struct ContentView: View {
    @StateObject var habitViewModel = HabitViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(habitViewModel.habits.indices, id: \.self) { index in
                    HStack {
                        Text(habitViewModel.habits[index].name)
                        Spacer()
                        Image(systemName: habitViewModel.habits[index].isCompletedToday ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(habitViewModel.habits[index].isCompletedToday ? .green : .gray)
                            .onTapGesture {
                                habitViewModel.habits[index].isCompletedToday.toggle()
                            }
                    }
                    .padding(.vertical, 5)
                }
            }
            .navigationTitle("Today's Habits")
        }
    }
}

#Preview {
    ContentView()
}
