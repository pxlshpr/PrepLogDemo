import SwiftUI
import SwiftSugar

struct DaySlider: View {
  
    let dayWidth: CGFloat

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
        
        func circle(
            at index: Int,
            _ numberOfDummies: Int
        ) -> some View {
            var isDummy: Bool {
                index < start + numberOfDummies
                ||
                index > end - numberOfDummies
            }
            return DayCircle(
                numberOfDays: index,
                numberOfDummies: numberOfDummies,
                scrolledNumberOfDays: $scrolledNumberOfDays,
                ignoreNextScroll: $ignoreNextScroll
            )
            .id(index)
            .frame(width: 91.06666666666666)
            .opacity(isDummy ? 0 : 1)
        }
        
        return GeometryReader { geometry in
            let width = geometry.size.width
//            let dayWidth = calculateDayWidth(for: width)
//            print("dayWidth is: \(dayWidth)")
            let dayWidth = 91.06666666666666
            let numberOfDummies = Int(floor((width / 2.0) / dayWidth))
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(start...end, id: \.self) { index in
                        circle(at: index, numberOfDummies)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(DayScrollTargetBehavior())
            .scrollPosition(id: $scrolledNumberOfDays, anchor: .center)
            .scrollIndicators(.hidden)
            .onAppear {
//                print("width: \(geometry.size.width)")
//
//                let dayWidth = calculateDayWidth(for: geometry.size.width)
//                self.dayWidth = dayWidth
//                DayWidth = dayWidth
//
//                let numberOfDummies = Int(floor((geometry.size.width / 2.0) / dayWidth))
//                self.numberOfDummies = numberOfDummies
//
//                /// Scroll to today
                self.numberOfDummies = numberOfDummies
                ignoreNextScroll = true
                scrolledNumberOfDays = 0 + numberOfDummies
            }
//            .onChange(of: geometry.size) { oldValue, newValue in
//                let dayWidth = calculateDayWidth(for: newValue.width)
//                self.dayWidth = dayWidth
//                DayWidth = dayWidth
//
//                let numberOfDummies = Int(floor((newValue.width / 2.0) / dayWidth))
//                self.numberOfDummies = numberOfDummies
//                print("Size changed to: \(newValue)")
//                print("dayWidth: \(self.dayWidth)")
//                print("numberOfDummies: \(self.numberOfDummies)")
//            }
        }
        .frame(height: DaySliderHeight)
        .onChange(of: scrolledNumberOfDays, scrolledNumberOfDaysChanged)
    }
    
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
