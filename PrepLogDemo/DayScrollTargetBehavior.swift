import SwiftUI

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
