//
//  Category.swift
//  ReminderApp
//
//  Created by 장예지 on 7/6/24.
//

import UIKit

enum Category: Int, CaseIterable {
    case today
    case expected
    case all
    case flag
    case completed
    
    var title: String {
        switch self {
        case .today:
            return "오늘"
        case .expected:
            return "예정"
        case .all:
            return "전체"
        case .flag:
            return "깃발 표시"
        case .completed:
            return "완료됨"
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .today:
            return .systemBlue
        case .expected:
            return .systemRed
        case .all:
            return .systemGray
        case .flag:
            return .systemYellow
        case .completed:
            return .systemGray
        }
    }
    
    var image: UIImage? {
        switch self {
        case .today:
            return UIImage(systemName: "note.text")
        case .expected:
            return UIImage(systemName: "calendar")
        case .all:
            return UIImage(systemName: "tray.fill")
        case .flag:
            return UIImage(systemName: "flag.fill")
        case .completed:
            return UIImage(systemName: "checkmark")
        }
    }
}
