import SwiftUI
import SwiftSugar

//let CaloriesColor = Color.green
//let ProteinColor = Color.blue
//let FatColor = Color.pink
//let CarbsColor = Color.yellow
//let MealsColor = Color.purple
//let MealsAccentColor = Color.purple

let CaloriesColor = Color.gray
let ProteinColor = Color.gray
let FatColor = Color.gray
let CarbsColor = Color.gray
let MealsColor = Color.gray
let MealsAccentColor = Color.gray

struct LogView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State var currentDate: Date = Date.now
    @State var savedDate: Date? = nil

    @State var transition: AnyTransition = .asymmetric(
        insertion: .move(edge: .leading),
        removal: .move(edge: .trailing)
    )
    
    var body: some View {
        Group {
            HStack(spacing: 0) {
                if horizontalSizeClass == .regular {
                    Text("Sidebar")
                        .frame(width: 400)
                }
                Divider()
                    .frame(width: 1)
                    .frame(maxHeight: .infinity)
                NavigationView {
                    content
                        .navigationTitle("Prep")
                        .navigationBarTitleDisplayMode(.inline)
                }
                .navigationViewStyle(.stack)
            }
        }
    }
    
    var content: some View {
        GeometryReader {
            let width = $0.size.width
            let dayWidth = calculateDayWidth(for: width)
            let numberOfDummies = Int(floor((width / 2.0) / dayWidth))
            DayWidth = dayWidth

            return ScrollView {
                
                /// This shouldn't be part of the `LazyVStack` otherwise it keeps getting refreshed
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

                LazyVStack {

                    if horizontalSizeClass == .compact {
                        NutritionSection(currentDate: $currentDate)
                    }
                    
                    MealsSection(
                        currentDate: $currentDate,
                        transition: $transition
                    )
                    
                }
            }
            .onChange(of: currentDate) { oldValue, newValue in
                transition = if newValue > oldValue {
                    .asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .leading)
                    )
                } else {
                    .asymmetric(
                        insertion: .move(edge: .leading),
                        removal: .move(edge: .trailing)
                    )
                }
            }
            .onChange(of: $0.size) { oldValue, newValue in
                savedDate = currentDate
            }
        }
    }
}

struct NutritionSection: View {
    
    @Environment(\.colorScheme) var colorScheme

    @Binding var currentDate: Date
    
    var body: some View {
        ZStack {
//            RoundedRectangle(cornerRadius: 5)
            Rectangle()
                .fill(Color.gray.opacity(colorScheme == .light ? 0.06 : 0.2))
            VStack(spacing: 0) {
                bar(
                    name: "Calories",
                    color: CaloriesColor,
                    percent: !currentDate.isToday ? 0.7 : 0.9,
                    showMenu: true
                )
                bar(
                    name: "Protein",
                    color: ProteinColor,
                    percent: !currentDate.isToday ? 0.95 : 1.0
                )
                bar(
                    name: "Fat",
                    color: FatColor,
                    percent: !currentDate.isToday ? 0.8 : 1.5
                )
                bar(
                    name: "Carbs",
                    color: CarbsColor,
                    percent: !currentDate.isToday ? 0.4 : 0.9
                )
            }
        }
        .padding(.bottom, 10)
        .animation(.snappy, value: currentDate)
    }
    
    func bar(name: String, color: Color, percent: Double, showMenu: Bool = false) -> some View {
        var barColor: Color {
            switch percent {
            case 1.0:
                .green
            case _ where percent > 1.0:
                .red
            default:
                color
            }
        }

        return VStack(spacing: 0) {
            HStack {
                Text(name)
                    .font(.headline)
                Spacer()
                if showMenu {
                    Menu {
                    } label: {
                        Image(systemName: "ellipsis")
                            .fontWeight(.semibold)
                            .foregroundStyle(color)
                            .frame(width: 44, alignment: .trailing)
                            .frame(height: 30)
                            .contentShape(Rectangle())
                    }
                }
            }
            .frame(height: 50)
            
            GeometryReader {
                let width = $0.size.width
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(Color(.systemGray5))
                    HStack(spacing: 0) {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundStyle(barColor)
                        Spacer()
                            .frame(width: width * min(max((1 - percent), 0), 1))
                    }
                }
            }
            
            Spacer().frame(height: 15)
        }
        .padding(.horizontal)
    }
}

struct MealsSection: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Binding var currentDate: Date
    @State var range: ClosedRange<Int> = 1...100

    @Binding var transition: AnyTransition
    
    var body: some View {
        LazyVStack {
            headerRow
                .padding(.horizontal)
            ForEach(range, id: \.self) { _ in
                dummyMeal1
                    .transition(transition)
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
//            RoundedRectangle(cornerRadius: 5)
            Rectangle()
                .fill(MealsColor.opacity(colorScheme == .light ? 0.06 : 0.2))
            VStack(spacing: 0) {
                HStack {
                    Text("11:00 am • Breakfast")
                        .font(.headline)
                    Spacer()
                    Menu {
                        Button("Edit Meal") {
                            
                        }
                        Button("Duplicate Meal") {
                            
                        }
                        Divider()
                        Button("Delete Meal", role: .destructive) {
                            
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .fontWeight(.semibold)
                            .foregroundStyle(MealsAccentColor)
                            .frame(width: 44, alignment: .trailing)
                            .frame(height: 30)
                            .contentShape(Rectangle())
//                            .background(.green)
                    }
//                    .background(.green)
                }
                .frame(height: 50)

                Divider()

                HStack(spacing: 0) {
                    Text("🥚")
                        .frame(width: 30, alignment: .leading)
                    Text("Egg")
                        .fontWeight(.medium)
                    Text(", Whole, Raw")
                        .foregroundStyle(.secondary)
                    Text(", Fresh")
                        .foregroundStyle(.secondary)
                    Text(" • 2 large")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .frame(height: 44)
                .contentShape(Rectangle())
                .draggable("Egg") {
                    HStack {
                        Text("🥚")
                            .font(.largeTitle)
                        Spacer().frame(width: 100)
                    }
                }

                Divider()
                    .padding(.leading, 30)

                HStack(spacing: 0) {
                    Text("🧈")
                        .frame(width: 30, alignment: .leading)
                    Text("Butter")
                        .fontWeight(.medium)
                    Text(", Unsalted")
                        .foregroundStyle(.secondary)
                    Text(", Lurpak")
                        .foregroundStyle(.tertiary)
                    Text(" • 25 g")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .frame(height: 44)
                .contentShape(Rectangle())
                .draggable("Butter") {
                    HStack {
                        Text("🧈")
                            .font(.largeTitle)
                        Spacer().frame(width: 100)
                    }
                }

                Divider()
                    .padding(.leading, 30)

                HStack {
                    Button {
                        
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                            .foregroundStyle(MealsAccentColor)
                    }
                    .frame(width: 30, alignment: .leading)
                    Spacer()
                    Text("487 kcal")
                        .font(.headline)
                }
                .frame(height: 50)
            }
//            .padding(.vertical, 10)
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
