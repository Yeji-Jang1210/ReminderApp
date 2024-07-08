//
//  ReminderModel.swift
//  ReminderApp
//
//  Created by 장예지 on 7/2/24.
//

import Foundation
import RealmSwift

class Category: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted(indexed: true) var name: String
    
    @Persisted var list: List<Reminder>
}

class Reminder: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var content: String?
    @Persisted var deadline: Date?
    @Persisted var tag: String?
    @Persisted var prioirty: Int?
    @Persisted var isComplete: Bool
    @Persisted var isFlag: Bool
    
    @Persisted(originProperty: "list") var category: LinkingObjects<Category>
    
    convenience init(title: String, content: String?, deadline: Date? = Date(), tag: String? = nil, priority: Int? = nil, isComplete: Bool = false, isFlag: Bool = false) {
        self.init()
        self.title = title
        self.content = content
        self.deadline = deadline
        self.tag = tag
        self.prioirty = priority
        self.isComplete = isComplete
        self.isFlag = isFlag
    }
    
    var formattedDate: String {
        guard let date = deadline else { return "" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM .dd"
        return formatter.string(from: date)
    }
    
    var hashTaggedString: String {
        guard let tag else { return "" }
        return "#\(tag)"
    }
}
