import Foundation

let DaySliderHeight: CGFloat = 100
var DayCircleRatio: CGFloat = 0.75

var DayWidth: CGFloat = 0

func circleWidthRange(for width: CGFloat) -> ClosedRange<Int> {
    switch width {
    case _ where width < 350:   30...50
    case 300..<500:             60...80
    case 500..<950:            80...100
    default:                    90...120
    }
}

func calculateDayWidth(for width: CGFloat) -> CGFloat {
    var min: (i: CGFloat, remainder: CGFloat)? = nil
    let range = circleWidthRange(for: width)
    for i in range {
        let remainder = width.truncatingRemainder(dividingBy: CGFloat(i))
        if let m = min {
            if remainder < m.remainder {
                min = (CGFloat(i), remainder)
            }
        } else {
            min = (CGFloat(i), remainder)
        }
    }

    /// `min` shouldn't be nil as long as we had at least 1 value in the earlier `range`
    let divided = width / min!.i
    var whole = floor(divided)
    if whole.truncatingRemainder(dividingBy: 2.0) == 0 {
        whole += 1
    }
    let optimal = width / whole
    return optimal
}

func calculateDayHeight(forDayWidth dayWidth: CGFloat) -> CGFloat {
    let padding = 100.0
    let topPadding = padding
    let bottomPadding = padding
    let spacing = 10.0
    let textHeight = 10.0

    return topPadding
    +
    textHeight
    +
    spacing
    +
    dayWidth
    +
    bottomPadding
}

//MARK: - Legacy

//import Foundation
//
//let MinDayCircleWidth: CGFloat = 80
//let MaxDayCircleWidth: CGFloat = 100
//let DaySliderHeight: CGFloat = 100
//var DayCircleRatio: CGFloat = 0.75
//
////let ConstantDayWidth = 91.06666666666666
//let ConstantDayWidth = 86.4
//var DayWidth: CGFloat = ConstantDayWidth
//
//func calculateDayWidth(for width: CGFloat) -> CGFloat {
//    var min: (i: CGFloat, remainder: CGFloat)? = nil
//    for i in Int(MinDayCircleWidth)...Int(MaxDayCircleWidth) {
//        let remainder = width.truncatingRemainder(dividingBy: CGFloat(i))
////        print("Checking: \(i): \(remainder)")
//        if let m = min {
//            if remainder < m.remainder {
//                min = (CGFloat(i), remainder)
//            }
//        } else {
//            min = (CGFloat(i), remainder)
//        }
//    }
//    
//    guard let min else {
//        fatalError()
//    }
////    print("Min is: \(min)")
//    let divided = width / min.i
//    var whole = floor(divided)
//    if whole.truncatingRemainder(dividingBy: 2.0) == 0 {
//        whole += 1
//    }
//    let optimal = width / whole
////    print("Divided = \(divided), whole = \(whole), optimal = \(optimal)")
//    return optimal
//}
