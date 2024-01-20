import SwiftUI
import SwiftSugar
import SwiftHaptics

struct DayCircle: View {
    
//    @Bindable var sliderGeometry: SliderGeometry
    
    let numberOfDays: Int
    let numberOfDummies: Int
    @Binding var scrolledNumberOfDays: Int?
//    @Binding var ms: Int?
    @Binding var ignoreNextScroll: Bool

    var body: some View {
        label
            .onTapGesture {
                print("👆🏽 Tapped: \(numberOfDays), ignoreNextScroll: \(ignoreNextScroll)")
                Haptics.feedback(style: .soft)
                ignoreNextScroll = true
                /// Crucial to set this to `nil` first, otherwise in edge case of tapping first visible circle (with the `numberOfDummies` offset handling scroll position for taps vs manual sliding differently)—the value doesn't appear to change, and therefore the scroll doesn't occur
                scrolledNumberOfDays = nil
                withAnimation {
                    scrolledNumberOfDays = numberOfDays + numberOfDummies
                }
            }
    }
    
    var date: Date {
        Date.now.moveDayBy(numberOfDays)
    }
    
    var label: some View {
        GeometryReader {
            let width = $0.size.width
            VStack {
                Text(date.weekdayUnambiguousLetter)
                    .font(.subheadline)
                    .foregroundStyle(Color(.secondaryLabel))
                ZStack {
                    Circle()
                        .fill(Color(.systemGray4))
                        .frame(
                            width: width * DayCircleRatio,
                            height: width * DayCircleRatio
                        )
                    Text("\(numberOfDays)")
                }
            }
            .frame(width: width, height: DaySliderHeight)
            .contentShape(Rectangle())
        }
    }
}
