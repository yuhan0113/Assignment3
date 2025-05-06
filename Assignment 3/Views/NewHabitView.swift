import SwiftUI


struct NewHabitView: View {
    @StateObject var viewModel: HabitViewModel = .init()
    
    var body: some View {
        VStack {
            Text("Add New Habit")
        }
    }
}

#Preview {
    NewHabitView()
}
