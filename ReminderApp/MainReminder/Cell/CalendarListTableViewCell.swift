//
//  CalendarListTableViewCell.swift
//  ReminderApp
//
//  Created by 장예지 on 7/7/24.
//

import UIKit
import SnapKit

class CalendarListTableViewCell: UITableViewCell {
    
    let stackView: UIStackView = {
        let object = UIStackView()
        object.axis = .horizontal
        return object
    }()
    
    let priorityImageView: UIImageView = {
        let object = UIImageView()
        object.contentMode = .scaleAspectFit
        return object
    }()
    
    let titleLabel: UILabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 16, weight: .bold)
        return object
    }()
    
    let subTitleLabel: UILabel = {
        let object = UILabel()
        object.textColor = .secondaryLabel
        object.font = .systemFont(ofSize: 12)
        return object
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
