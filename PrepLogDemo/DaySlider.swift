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

    @State var scrollTask: Task<Void, Error>? = nil
    
    @Binding var width: CGFloat
    init(
        dayWidth: CGFloat,
        numberOfDummies: Int,
        width: Binding<CGFloat>
    ) {
        self.dayWidth = dayWidth
        self.numberOfDummies = numberOfDummies
        print("✨ DaySlider.init()")
        _width = width
    }
    
    func refreshScroll() {
        scrollTask?.cancel()
        scrollTask = Task {
            let numberOfDays = currentDate.numberOfDaysFrom(Date.now)
            try await sleepTask(0.3)
            try Task.checkCancellation()
            await MainActor.run {
                scrollToNumberOfDays(numberOfDays)
            }

//            try await sleepTask(0.2)
//            try Task.checkCancellation()
//            await MainActor.run {
//                /// Backup scroll (in case the first one was too quick)
//                scrollToNumberOfDays(numberOfDays)
//            }
        }
    }
    
    func scrollToNumberOfDays(_ numberOfDays: Int) {
        self.ignoreNextScroll = true
        self.scrolledNumberOfDays = nil
        withAnimation {
            self.scrolledNumberOfDays = numberOfDays + numberOfDummies
        }
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
        .onChange(of: width) { oldValue, newValue in
            print("width changed to: \(newValue)")
            refreshScroll()
        }
        .onChange(of: scrolledNumberOfDays) { oldValue, newValue in
            guard newValue != nil else {
                /// Make sure we're ignoring the corrective setting of `scrolledNumberOfDays` to `nil` in `DayCircle` because otherwise we'll be setting `ignoreNextScroll` to `false` and not correctly setting the date on the next (actual) change of `scrolledNumberOfDays`
                return
            }
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
//        .fixedSize(horizontal: true, vertical: true)
//        .frame(height: DaySliderHeight)
        .frame(height: calculateDayHeight(forDayWidth: dayWidth))
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
            .font(horizontalSizeClass == .compact ? .title2 : .largeTitle)
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
