//
//  ReminderTableViewCell.swift
//  ReminderApp
//
//  Created by 장예지 on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift

final class ReminderTableViewCell: BaseTableViewCell {
    
    let checkButton: UIButton = {
        let object = UIButton()
        object.setImage(UIImage(systemName: "circle.circle"), for: .selected)
        object.setImage(UIImage(systemName: "circle"), for: .normal)
        object.tintColor = .lightGray
        return object
    }()
    
    let titleLabel: UILabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 16)
        return object
    }()
    
    let contentLabel: UILabel = {
        let object = UILabel()
        object.textColor = .lightGray
        object.font = .systemFont(ofSize: 14)
        return object
    }()
    
    let dateLabel: UILabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 14)
        object.textColor = .lightGray
        return object
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        contentView.addSubview(checkButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(dateLabel)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        checkButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
            make.size.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(checkButton.snp.centerY)
            make.leading.equalTo(checkButton.snp.trailing).offset(8)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    public func fetchData(_ item: Reminder){
        titleLabel.text = item.title
        contentLabel.text = item.content
        dateLabel.text = item.formattedDate
    }
}
