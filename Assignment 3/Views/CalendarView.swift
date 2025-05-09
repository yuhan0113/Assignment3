import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: HabitViewModel
    @State private var displayMonth: Date = Date()

    private var monthDates: [Date] {
        let calendar = Calendar.current
        guard
            let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: displayMonth)),
            let dayRange = calendar.range(of: .day, in: .month, for: displayMonth)
        else { return [] }

        return dayRange.map { offset in
            calendar.date(byAdding: .day, value: offset - 1, to: monthStart)!
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                // Month selector
                HStack {
                    Button(action: { changeMonth(by: -1) }) {
                        Image(systemName: "chevron.left")
                    }
                    Spacer()
                    Text(monthTitle)
                        .font(.headline)
                    Spacer()
                    Button(action: { changeMonth(by: 1) }) {
                        Image(systemName: "chevron.right")
                    }
                }
                .padding(.horizontal)

                // Days grid
                let columns = Array(repeating: GridItem(.flexible()), count: 7)
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(monthDates, id: \.self) { date in
                        let day = Calendar.current.component(.day, from: date)
                        let isToday = Calendar.current.isDate(date, inSameDayAs: Date())
                        // Simple highlight if any habit was marked today
                        let didCompleteAny = isToday
                            ? viewModel.habits.contains(where: { $0.isCompletedToday })
                            : false

                        ZStack {
                            Circle()
                                .frame(width: 32, height: 32)
                                .foregroundColor(
                                    didCompleteAny
                                    ? Color.green.opacity(0.3)
                                    : (isToday ? Color.blue.opacity(0.2) : Color.clear)
                                )

                            Text("\(day)")
                                .foregroundColor(
                                    isToday
                                    ? .blue
                                    : (didCompleteAny ? .green : .primary)
                                )
                        }
                    }
                }
                .padding(.vertical)

                Spacer()
            }
            .navigationTitle("Calendar")
        }
    }

    private var monthTitle: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "LLLL yyyy"
        return fmt.string(from: displayMonth)
    }

    private func changeMonth(by delta: Int) {
        if let next = Calendar.current.date(byAdding: .month, value: delta, to: displayMonth) {
            displayMonth = next
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(viewModel: HabitViewModel())
    }
}
