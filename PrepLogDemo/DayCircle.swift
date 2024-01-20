import SwiftUI
import SwiftSugar

struct DayCircle: View {
    
//    @Bindable var sliderGeometry: SliderGeometry
    
    let numberOfDays: Int
    let numberOfDummies: Int
    @Binding var scrolledNumberOfDays: Int?
    @Binding var ignoreNextScroll: Bool

    var body: some View {
        label
            .onTapGesture {
                ignoreNextScroll = true
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
//                            width: dayWidth * DayCircleRatio,
//                            height: dayWidth * DayCircleRatio
                            width: width * DayCircleRatio,
                            height: width * DayCircleRatio
                        )
                    Text("\(numberOfDays)")
                }
            }
//            .frame(width: dayWidth, height: DaySliderHeight)
            .frame(width: width, height: DaySliderHeight)
        }
    }
    
//    var dayWidth: CGFloat {
//        sliderGeometry.dayWidth
//    }
}
