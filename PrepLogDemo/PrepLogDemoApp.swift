import SwiftUI

@main
struct PrepLogDemoApp: App {
    
//    @State var sliderGeometry = SliderGeometry.shared
    
    var body: some Scene {
        WindowGroup {
            LogView()
//                .environment(sliderGeometry)
//            ContentView()
        }
    }
}

//TODO: Next
/// [ ] Making `sliderGeometry.dayWidth` a replacement for DayWidth
/// [ ] Use SliderGeometry.shared in the ScrollTargetBehavior
