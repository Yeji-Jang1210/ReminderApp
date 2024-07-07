//
//  ReminderRepository.swift
//  ReminderApp
//
//  Created by 장예지 on 7/6/24.
//

import Foundation
import RealmSwift

enum ReminderRepositoryError: Error {
    case addFailed
    
    var text: String {
        switch self {
        case .addFailed:
            return "저장에 실패했습니다."
        }
    }
}

protocol ReminderRepositoryProtocol {
    // Create
    func addItem(item: Reminder, completion: @escaping ((ReminderRepositoryError?)->Void))
    
    // Read
    func fetch() -> Results<Reminder>
    
    // Delete
    func deleteItem(item: Reminder)
    
    //update
    func updateComplete(item: Reminder, completion: @escaping (()->Void))
    func updateFlag(item: Reminder, completion: @escaping (()->Void))
}

class ReminderRepository: ReminderRepositoryProtocol {
    
    private let realm = try! Realm()
    
    func addItem(item: Reminder, completion: @escaping ((ReminderRepositoryError?)->Void)) {
        do{
            try realm.write{
                realm.add(item)
                completion(nil)
            }
        } catch {
            completion(ReminderRepositoryError.addFailed)
        }
    }
    
    func fetch() -> RealmSwift.Results<Reminder> {
        return realm.objects(Reminder.self)
    }
    
    func deleteItem(item: Reminder) {
        try! realm.write{
            realm.delete(item)
        }
    }
    
    func fetchFilterForCategory(_ filter: Category) -> Results<Reminder> {
        let list = fetch()

        switch filter {
        case .today:
            return fetchFilterForDate()
        case .expected:
            let (startDate, endDate) = getSpecificStartAndEndDate()
            return list.filter("deadline > %@", endDate)
        case .all:
            return list
        case .flag:
            return list.where{ $0.isFlag }
        case .completed:
            return list.where { $0.isComplete }
        }
    }
    
    func fetchFilterForDate(_ date: Date = Date()) -> Results<Reminder> {
        let list = fetch()
        let (startDate, endDate) = getSpecificStartAndEndDate(date: date)
        
        return list.filter("deadline >= %@ AND deadline <= %@", startDate, endDate)
    }
    
    func updateComplete(item: Reminder, completion: @escaping (()->Void)){
        try! realm.write {
            item.isComplete.toggle()
            completion()
        }
    }
    
    func updateFlag(item: Reminder, completion: @escaping (()->Void)){
        try! realm.write {
            item.isFlag.toggle()
            completion()
        }
    }
    
    private func getSpecificStartAndEndDate(date: Date = Date()) -> (start: Date, end: Date) {
        let calendar = Calendar.current
        let now = date

        let startOfDay = calendar.startOfDay(for: now)
        var components = DateComponents()
        components.day = 1
        components.second = -1
        let endOfDay = calendar.date(byAdding: components, to: startOfDay)!

        return (startOfDay, endOfDay)
    }
}
