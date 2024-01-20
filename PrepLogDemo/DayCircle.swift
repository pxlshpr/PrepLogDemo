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
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: K.DayCircle.Padding.top)
                Text(date.weekdayUnambiguousLetter)
                    .font(.subheadline)
                    .foregroundStyle(Color(.secondaryLabel))
                    .frame(height: K.DayCircle.text)
                Spacer()
                    .frame(height: K.DayCircle.Padding.spacing)
                ZStack {
                    Circle()
                        .fill(Color(.systemGray4))
                        .frame(
                            width: width * K.DayCircle.ratio,
                            height: width * K.DayCircle.ratio
                        )
                    Text("\(numberOfDays)")
                }
                Spacer()
                    .frame(height: K.DayCircle.Padding.bottom)
            }
//            .frame(width: width, height: K.DayCircle.height(dayWidth: width))
            .frame(width: width)
//            .frame(maxHeight: .infinity)
            .contentShape(Rectangle())
        }
    }
}

struct K {
    struct DayCircle {
        struct Padding {
            static let top: CGFloat = 5
            static let bottom: CGFloat = 20
            static let spacing: CGFloat = 10
        }
        static let text: CGFloat = 20
        static let ratio: CGFloat = 0.75
        
        static func height(dayWidth: CGFloat) -> CGFloat {
            Padding.top
            + text
            + Padding.spacing
            + (dayWidth * ratio)
            + Padding.bottom
        }
    }
}
