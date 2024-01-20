import SwiftUI
import SwiftSugar

struct LogView: View {
    
    @State var currentDate: Date = Date.now
    @State var savedDate: Date? = nil

    var body: some View {
        NavigationView {
            content
                .navigationTitle("Prep")
                .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
    
    var content: some View {
        GeometryReader {
            let width = $0.size.width
            let dayWidth = calculateDayWidth(for: width)
            let numberOfDummies = Int(floor((width / 2.0) / dayWidth))
            DayWidth = dayWidth

            return ScrollView {
                DaySlider(
                    currentDate: $currentDate,
                    savedDate: $savedDate,
                    dayWidth: dayWidth,
                    numberOfDummies: numberOfDummies,
                    width: Binding<CGFloat>(
                        get: { width },
                        set: { _ in }
                    )
                )
                
                MealsSection(currentDate: $currentDate)
            }
            .onChange(of: $0.size) { oldValue, newValue in
                savedDate = currentDate
            }
        }
    }
}

struct MealsSection: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Binding var currentDate: Date
    @State var range: ClosedRange<Int> = 1...100
    
    var body: some View {
        LazyVStack {
            headerRow
                .padding(.horizontal)
            ForEach(range, id: \.self) { _ in
                dummyMeal1
            }
        }
        .onChange(of: currentDate) { oldValue, newValue in
            withAnimation {
                range = currentDate.isToday ? 1...100 : 1...1
            }
        }
    }
    
    var dummyMeal1: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.purple.opacity(colorScheme == .light ? 0.06 : 0.2))
            VStack {
                HStack {
                    Text("11:00 am • Breakfast")
                        .font(.headline)
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                            .foregroundStyle(.purple)
                    }
                }

                HStack {
                    Text("🥚")
                    HStack(spacing: 0) {
                        Text("Egg")
                            .fontWeight(.medium)
                        Text(", Whole, Raw")
                            .foregroundStyle(.secondary)
                        Text(", Fresh")
                            .foregroundStyle(.secondary)
                        Text(" • 2 large")
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)

                HStack {
                    Text("🧈")
                    HStack(spacing: 0) {
                        Text("Butter")
                            .fontWeight(.medium)
                        Text(", Unsalted")
                            .foregroundStyle(.secondary)
                        Text(", Lurpak")
                            .foregroundStyle(.tertiary)
                        Text(" • 25 g")
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

            }
            .padding(.vertical, 10)
            .padding(.horizontal)
        }
        .padding(.bottom, 10)
    }
    
    var headerRow: some View {
        HStack {
            Text("Meals")
                .font(.system(.title2, design: .rounded, weight: .semibold))
            Spacer()
        }
    }
}

#Preview {
    LogView()
}
