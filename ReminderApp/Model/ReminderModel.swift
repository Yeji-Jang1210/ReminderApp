//
//  ReminderModel.swift
//  ReminderApp
//
//  Created by 장예지 on 7/2/24.
//

import Foundation
import RealmSwift

class Reminder: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var content: String?
    @Persisted var deadline: Date?
    
    convenience init(title: String, content: String?, deadline: Date? = Date()) {
        self.init()
        self.title = title
        self.content = content
        self.deadline = deadline
    }
    
    var formattedDate: String {
        guard let date = deadline else { return "" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM .dd"
        return formatter.string(from: date)
    }
}
