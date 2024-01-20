import Foundation

let MinDayCircleWidth: CGFloat = 80
let MaxDayCircleWidth: CGFloat = 100
let DaySliderHeight: CGFloat = 100
var DayCircleRatio: CGFloat = 0.75

//let ConstantDayWidth = 91.06666666666666
let ConstantDayWidth = 86.4
var DayWidth: CGFloat = ConstantDayWidth

func calculateDayWidth(for width: CGFloat) -> CGFloat {
    var min: (i: CGFloat, remainder: CGFloat)? = nil
    for i in Int(MinDayCircleWidth)...Int(MaxDayCircleWidth) {
        let remainder = width.truncatingRemainder(dividingBy: CGFloat(i))
//        print("Checking: \(i): \(remainder)")
        if let m = min {
            if remainder < m.remainder {
                min = (CGFloat(i), remainder)
            }
        } else {
            min = (CGFloat(i), remainder)
        }
    }
    
    guard let min else {
        fatalError()
    }
//    print("Min is: \(min)")
    let divided = width / min.i
    var whole = floor(divided)
    if whole.truncatingRemainder(dividingBy: 2.0) == 0 {
        whole += 1
    }
    let optimal = width / whole
//    print("Divided = \(divided), whole = \(whole), optimal = \(optimal)")
    return optimal
}
