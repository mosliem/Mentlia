
import UIKit
import Charts

enum days: Int{
    case Sat = 1
    case Sun = 2
    case Mon = 3
    case TUE = 4
    case Wed = 5
    case THU = 6
    case Fri = 7
    
    var label: String{
        switch self {
     
        case .Sat:
            return "SAT"
        case .Sun:
            return "SUN"
        case .Mon:
            return "MON"
        case .TUE:
            return "TUE"
        case .Wed:
            return "WED"
        case .THU:
            return "THU"
        case .Fri:
            return "FRI"
        }
    }
}

final class XAxisData: AxisValueFormatter{
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let intVal = Int(value)
        let daysLabel = days(rawValue: intVal)
        return daysLabel?.label ?? ""
    }

    
}
