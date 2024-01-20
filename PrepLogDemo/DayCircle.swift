import SwiftUI
import SwiftSugar
import SwiftHaptics

struct DayCircle: View {
    
//    @Bindable var sliderGeometry: SliderGeometry
    
    let numberOfDays: Int
    let numberOfDummies: Int
    @Binding var s: Int?
    @Binding var ms: Int?
    @Binding var ignoreNextScroll: Bool

    var body: some View {
        label
            .onTapGesture {
                print("👆🏽 Tapped: \(numberOfDays), ignoreNextScroll: \(ignoreNextScroll)")
                Haptics.feedback(style: .soft)
                ignoreNextScroll = true
                withAnimation {
                    if let s, let ms {
                        print("    s: \(s), ms: \(ms)")
                    }
                    print("    Setting ms to: \(numberOfDays + numberOfDummies)")
                    ms = numberOfDays + numberOfDummies
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
