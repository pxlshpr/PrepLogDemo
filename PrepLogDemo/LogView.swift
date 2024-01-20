import SwiftUI
import SwiftSugar

struct LogView: View {
    
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
            Text("Log goes here")
        }
    }
}

let DayCircleWidth: CGFloat = 80
let DaySliderHeight: CGFloat = 100

struct DaySlider: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("Today, 20 January")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            Divider()
            Triangle()
                .fill(Color(.label))
                .frame(width: 15, height: 12)
            scrollView
        }
    }
    
    var scrollView: some View {
        GeometryReader {
            let size = $0.size
            
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(-3000...365, id: \.self) { numberOfDays in
                        let date = Date.now.moveDayBy(numberOfDays)
                        DayCircle(date: date)
                    }
                }
                .padding(.horizontal, (size.width - DayCircleWidth) / 2) /// centers viewAligned scrolling
                .scrollTargetLayout()
            }
                    .scrollTargetBehavior(.viewAligned)
//            .scrollTargetBehavior(.paging)
//            .defaultScrollAnchor(.some())
        }
        .scrollIndicators(.hidden)
        .frame(height: DaySliderHeight)
    }
}

extension Date {
    func weekday() -> Int? {
        Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}

struct DayCircle: View {
    let date: Date
    
    var dayLetter: String {
        switch date.weekday() {
        case 1:     "Su"
        case 2:     "M"
        case 3:     "Tu"
        case 4:     "W"
        case 5:     "Th"
        case 6:     "F"
        case 7:     "Sa"
        default:    ""
        }
    }
    
    var body: some View {
        VStack {
            Text(dayLetter)
                .font(.subheadline)
                .foregroundStyle(Color(.secondaryLabel))
            Circle()
                .fill(Color(.systemGray4))
                .frame(width: 60, height: 60)
//                .padding()
        }
        .frame(width: DayCircleWidth, height: DaySliderHeight)
    }
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
