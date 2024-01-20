import SwiftUI
import SwiftSugar

struct LogView: View {
    
    @State var currentDate: Date = Date.now
    @State var savedDate: Date? = nil

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
            let numberOfDummiesF = (width / 2.0) / dayWidth
            print("numberOfDummiesF: \(numberOfDummiesF)")
            let numberOfDummies = Int(floor(numberOfDummiesF))
            print("numberOfDummies: \(numberOfDummies)")
            print("dayWidth: \(dayWidth)")
            DayWidth = dayWidth
            return ScrollView {
                DaySlider(
                    currentDate: $currentDate,
                    savedDate: $savedDate,
                    dayWidth: dayWidth,
                    numberOfDummies: numberOfDummies,
                    width: Binding<CGFloat>(
                        get: { width },
                        set: { _ in }
                    )
                )
            }
            .onChange(of: $0.size) { oldValue, newValue in
                savedDate = currentDate
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    savedDate = nil
                }
            }
        }
    }
}

#Preview {
    LogView()
}
