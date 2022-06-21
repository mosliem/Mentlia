//
//  AxisData.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 3/24/22.
//

import UIKit
import Charts


enum Mood: Int {
    case Sad = 1
    case Angry = 2
    case Neutral = 3
    case Happy = 4

    var label : String{
        switch self {
        case .Happy:
            return "😄"
        case .Neutral:
            return "🙂"
        case .Sad:
            return "😔"
        case .Angry:
            return "😠"

        }
    }
    
    var count: Int {
        return 4
    }
}

final class YAxisData: AxisValueFormatter{
    
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let intVal = Int(value)
        let MoodLabel = Mood(rawValue: intVal)
        return MoodLabel?.label ?? ""
    }

    
}


//
//class MyValueFormatter: ValueFormatter {
//    var hiddenEntries: [ChartDataEntry?] = []
//
//    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
//        return hiddenEntries.contains(entry) ? "" : "\(value)"
//    }
//}
