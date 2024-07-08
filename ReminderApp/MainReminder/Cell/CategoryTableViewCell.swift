//
//  CategoryTableViewCell.swift
//  ReminderApp
//
//  Created by 장예지 on 7/8/24.
//

import UIKit

class CategoryTableViewCell: BaseTableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        textLabel?.font = .systemFont(ofSize: 12)
        detailTextLabel?.font = .systemFont(ofSize: 12)
    }

    public func setTitle(title: String){
        textLabel?.text = title
    }
}
