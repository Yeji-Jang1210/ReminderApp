//
//  Date+Extension.swift
//  ReminderApp
//
//  Created by 장예지 on 7/3/24.
//

import Foundation

extension Date {
    func getString(format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func isSameDay(as date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: date)
    }
}
