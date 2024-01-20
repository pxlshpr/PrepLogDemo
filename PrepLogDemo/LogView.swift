import SwiftUI
import SwiftSugar

struct LogView: View {
    
//    @Environment(SliderGeometry.self) var sliderGeometry: SliderGeometry
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle("Prep")
                .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
    
    var content: some View {
        ScrollView {
            DaySlider()
//            Text("Log goes here")
        }
    }
}

//let DayCircleWidth: CGFloat = 80
//let dayCircleWidth: CGFloat = 85
let DaySliderHeight: CGFloat = 100

let MinDayCircleWidth: CGFloat = 80
let MaxDayCircleWidth: CGFloat = 100

var DayCircleRatio: CGFloat = 0.75

var DayWidth: CGFloat = MinDayCircleWidth

//class SliderGeometry: Observable {
//    static let shared = SliderGeometry()
////    var dayWidth: CGFloat = MinDayCircleWidth
//    var dayWidth: CGFloat = 86.4
////    var dayWidth: CGFloat = 91.06666666666666
//}

struct DaySlider: View {
    
//    @Bindable var sliderGeometry: SliderGeometry
    @State var scrolledNumberOfDays: Int? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            titleButton
            Divider()
            Triangle()
                .fill(Color(.label))
                .frame(width: 15, height: 12)
            scrollView
        }
    }
    
    var titleButton: some View {
        Text(dateTitle)
            .foregroundStyle(Color(.label))
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.bottom, 10)
            .onTapGesture {
                ignoreNextScroll = true
                withAnimation {
                    scrolledNumberOfDays = 0 + numberOfDummies
                }
            }
    }
    
    var dateTitle: String {
        currentDate.logTitle
    }
    
    @State var currentDate: Date = Date.now
    @State var ignoreNextScroll = false
    @State var numberOfDummies: Int = 0
    
    var getCurrentDate: Date {
        guard let scrolledNumberOfDays else { return Date.now }
        return Date.now.moveDayBy(scrolledNumberOfDays)
    }
    
//    let start = -16
//    let end = 16
    let start = -3000
    let end = 365

    var scrollView: some View {
        
        func circle(at index: Int, ignoring numberOfDummies: Int) -> some View {
            var isDummy: Bool {
                index < start + numberOfDummies
                ||
                index > end - numberOfDummies
            }
            return DayCircle(
//                sliderGeometry: sliderGeometry,
                numberOfDays: index,
                numberOfDummies: numberOfDummies,
                scrolledNumberOfDays: $scrolledNumberOfDays,
                ignoreNextScroll: $ignoreNextScroll
            )
            .id(index)
//            .background(.green)
            .opacity(isDummy ? 0 : 1)
        }
        
        return GeometryReader {
            let width = $0.size.width
            let dayWidth = dayWidth(for: width)
            DayWidth = dayWidth
            self.numberOfDummies = Int(floor((width / 2.0) / dayWidth))
            return ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(start...end, id: \.self) { index in
                        circle(at: index, ignoring: numberOfDummies)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(DayScrollTargetBehavior())
            .scrollPosition(id: $scrolledNumberOfDays, anchor: .center)
            .onAppear {
                print("width: \(width)")
                ignoreNextScroll = true
                scrolledNumberOfDays = 0 + numberOfDummies
//                self.numberOfDummies = numberOfDummies
            }
            .scrollIndicators(.hidden)
        }
        .frame(height: DaySliderHeight)
        .onChange(of: scrolledNumberOfDays, scrolledNumberOfDaysChanged)
    }
    
//    var dayWidth: CGFloat {
//        sliderGeometry.dayWidth
//    }

    
    func scrolledNumberOfDaysChanged(oldValue: Int?, newValue: Int?) {
        var date = getCurrentDate
        if ignoreNextScroll {
            date = date.moveDayBy(-numberOfDummies)
            ignoreNextScroll = false
        }
        self.currentDate = date
//        print("scrolledNumberOfDays changed to: \(String(describing: newValue))")
    }
}

func dayWidth(for width: CGFloat) -> CGFloat {
    var min: (i: CGFloat, remainder: CGFloat)? = nil
    for i in Int(MinDayCircleWidth)...Int(MaxDayCircleWidth) {
        let remainder = width.truncatingRemainder(dividingBy: CGFloat(i))
        print("Checking: \(i): \(remainder)")
        if let m = min {
            if remainder < m.remainder {
                min = (CGFloat(i), remainder)
            }
        } else {
            min = (CGFloat(i), remainder)
        }
    }
    
    guard let min else {
        fatalError()
    }
    print("Min is: \(min)")
    let divided = width / min.i
    var whole = floor(divided)
    if whole.truncatingRemainder(dividingBy: 2.0) == 0 {
        whole += 1
    }
    let optimal = width / whole
    print("Divided = \(divided), whole = \(whole), optimal = \(optimal)")
    return optimal
}

struct DayScrollTargetBehavior: ScrollTargetBehavior {
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        /// Use `target.midX` and see which dayCircle's midX its closest to (in relative terms of where its placed in `contentSize`)
        /// Now determine what the `target.rect.origin.x` should be to align it in the center and move there
//        DayCircleWidth

        /// origins at 0, 80, 160, etc.
        /// mid points at 40, 120, etc.
        /// let w = DayCircleWidth
        /// midPoint for 1 = (1 * 80) + 40 = (1 * w) + (w/2)
        let w = DayWidth
//        let w = SliderGeometry.shared.dayWidth
        
        func midX(forIndex index: Int) -> CGFloat {
            (CGFloat(index) * w) + (w/2.0)
        }

        func targetX(forMidX midX: CGFloat) -> CGFloat {
            midX - (context.containerSize.width / 2.0)
        }
        
        func targetX(forIndex index: Int) -> CGFloat {
            targetX(forMidX: midX(forIndex: index))
        }
        
        func index(atMidX midX: CGFloat) -> Int {
            let multiple = midX / w
            let index = floor(multiple)
            return Int(index)
        }
        
//        print("Getting index at target.rect.midX: \(target.rect.midX)")
        let index = index(atMidX: target.rect.midX)
//        print("index = \(index)")
//        print("")
        target.rect.origin.x = targetX(forIndex: index)
        //        if target.rect.minY < (context.containerSize.height / 3.0), /// If the target is *close* to the top of the scorll view
//           context.velocity.dy < 0.0 /// and the scroll is flicked up
//        {
//            /// I'll prefer to scroll to the exact top of the scrollview
//            target.rect.origin.y = 0.0
//        }
    }
}

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

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))

        return path
    }
}

#Preview {
    LogView()
}
