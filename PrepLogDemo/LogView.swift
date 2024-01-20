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
            print("dayWidth: \(dayWidth)")
            DayWidth = dayWidth
            return ScrollView {
                DaySlider(dayWidth: dayWidth)
            }
        }
    }
}

#Preview {
    LogView()
}
