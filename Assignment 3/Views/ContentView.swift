import SwiftUI

struct ContentView: View {
    @State private var habits: [Habit] = [
        Habit(name: "Habit 1", isCompletedToday: false),
        Habit(name: "Habit 2", isCompletedToday: true),
        Habit(name: "Habit 3", isCompletedToday: false)
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(habits.indices, id: \.self) { index in
                    HStack {
                        Text(habits[index].name)
                        Spacer()
                        Image(systemName: habits[index].isCompletedToday ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(habits[index].isCompletedToday ? .green : .gray)
                            .onTapGesture {
                                habits[index].isCompletedToday.toggle()
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
