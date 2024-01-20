import SwiftUI
import SwiftSugar

struct DaySlider: View {
  
    let dayWidth: CGFloat
    let numberOfDummies: Int

    @State var currentDate: Date = Date.now
    @State var ignoreNextScroll = false
    
    @State var s: Int? = nil
    @State var ms: Int? = nil

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
            s = 0 + numberOfDummies
        }
        .onChange(of: s) { oldValue, newValue in
            if let newValue {
                print("s changed to: \(newValue)")
            } else {
                print("s changed to: nil")
            }
//            var date = getCurrentDate
//            if ignoreNextScroll {
//                date = date.moveDayBy(-numberOfDummies)
//                ignoreNextScroll = false
//            }
//            self.currentDate = date
        }
        .onChange(of: ms) { oldValue, newValue in
            withAnimation {
                s = newValue
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
                    circle(at: index)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(DayScrollTargetBehavior())
        .scrollPosition(id: $s, anchor: .center)
        .scrollIndicators(.hidden)
        .frame(height: DaySliderHeight)
    }
    
    func circle(
        at index: Int
    ) -> some View {
        var isDummy: Bool {
            index < start + numberOfDummies
            ||
            index > end - numberOfDummies
        }
        return DayCircle(
            numberOfDays: index,
            numberOfDummies: numberOfDummies,
            s: $s,
            ms: $ms,
            ignoreNextScroll: $ignoreNextScroll
        )
        .id(index)
        .frame(width: dayWidth)
        .opacity(isDummy ? 0 : 1)
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
                    s = 0 + numberOfDummies
                }
            }
    }
    
    var dateTitle: String {
        currentDate.logTitle
    }
    
    var getCurrentDate: Date {
        guard let s else { return Date.now }
        return Date.now.moveDayBy(s)
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
