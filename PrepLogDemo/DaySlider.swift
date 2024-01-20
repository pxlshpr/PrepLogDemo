import SwiftUI
import SwiftSugar

struct DaySlider: View {
  
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    let dayWidth: CGFloat
    let numberOfDummies: Int

    @State var currentDate: Date = Date.now
    @State var ignoreNextScroll = false
    
    @State var scrolledNumberOfDays: Int? = nil

//    let start = -16
//    let end = 16
    let start = -3000
    let end = 365

    init(dayWidth: CGFloat, numberOfDummies: Int) {
        self.dayWidth = dayWidth
        self.numberOfDummies = numberOfDummies
        print("✨ DaySlider.init()")
    }
    
    var body: some View {
        VStack(spacing: 0) {
            titleButton
            Divider()
            triangle
            scrollView
        }
        .onAppear {
            /// Scroll to today
            print("👁️ DaySlider.onAppear")
            ignoreNextScroll = true
            scrolledNumberOfDays = 0 + numberOfDummies
        }
        .onChange(of: scrolledNumberOfDays) { oldValue, newValue in
            var date = getCurrentDate
            if ignoreNextScroll {
                date = date.moveDayBy(-numberOfDummies)
                ignoreNextScroll = false
            }
            self.currentDate = date
        }
    }
    
    var scrollView: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(start...end, id: \.self) { index in
                    dayCircle(at: index)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(DayScrollTargetBehavior())
        .scrollPosition(id: $scrolledNumberOfDays, anchor: .center)
        .scrollIndicators(.hidden)
        .frame(height: DaySliderHeight)
    }
    
    func dayCircle(at index: Int) -> some View {
        var isDummy: Bool {
            index < start + numberOfDummies || index > end - numberOfDummies
        }
        return DayCircle(
            numberOfDays: index,
            numberOfDummies: numberOfDummies,
            scrolledNumberOfDays: $scrolledNumberOfDays,
            ignoreNextScroll: $ignoreNextScroll
        )
        .id(index)
        .frame(width: dayWidth)
        .opacity(isDummy ? 0 : 1)
    }
    
    var titleButton: some View {
        Text(dateTitle)
            .foregroundStyle(Color(.label))
            .font(horizontalSizeClass == .compact ? .title : .largeTitle)
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
    
    var getCurrentDate: Date {
        guard let scrolledNumberOfDays else { return Date.now }
        return Date.now.moveDayBy(scrolledNumberOfDays)
    }
    
    var triangle: some View {
        Triangle()
            .fill(Color(.label))
            .frame(width: 15, height: 12)
    }
}

#Preview {
    LogView()
}
