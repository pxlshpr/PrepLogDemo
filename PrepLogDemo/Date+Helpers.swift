import Foundation

extension Date {
    var logTitle: String {
        var prefix: String? {
            if isToday { "Today" }
            else if isYesterday { "Yesterday" }
            else if isTomorrow { "Tomorrow" }
            else if isThisYear { weekdayName }
            else { nil }
        }
        
        return if let prefix {
            "\(prefix), \(mediumDateString)"
        } else {
            mediumDateString
        }
    }
    
    var mediumDateString: String {
        let formatter = DateFormatter()
        if isThisYear {
            formatter.dateFormat = "d MMMM"
        } else {
            formatter.dateFormat = "d MMMM yyyy"
        }
        return formatter.string(from: self)
    }
    
    var isThisYear: Bool {
        year == Date.now.year
    }
    
    var weekdayName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    
    var weekdayNumber: Int? {
        Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    var weekdayUnambiguousLetter: String {
        switch weekdayNumber {
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
}
