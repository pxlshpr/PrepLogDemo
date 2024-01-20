import SwiftUI
import SwiftSugar

struct LogView: View {
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle("Prep")
                .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
    
    var content: some View {
        GeometryReader {
            let width = $0.size.width
            let dayWidth = calculateDayWidth(for: width)
            let numberOfDummies = Int(floor((width / 2.0) / dayWidth))
            print("dayWidth: \(dayWidth)")
            DayWidth = dayWidth
            return ScrollView {
                DaySlider(
                    dayWidth: dayWidth,
                    numberOfDummies: numberOfDummies
                )
            }
        }
    }
}

#Preview {
    LogView()
}
