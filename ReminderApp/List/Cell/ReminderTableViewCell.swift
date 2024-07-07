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
    
    let backView = UIView()
    
    let contentStackView: UIStackView = {
        let object = UIStackView()
        object.axis = .horizontal
        object.spacing = 10
        return object
    }()
    
    let reminderImageView: UIImageView = {
        let object = UIImageView()
        object.contentMode = .scaleAspectFill
        object.clipsToBounds = true
        object.layer.cornerRadius = 4
        object.backgroundColor = .lightGray
        object.isHidden = true
        return object
    }()
    
    let stackView: UIStackView = {
        let object = UIStackView()
        object.axis = .horizontal
        object.alignment = .fill
        object.distribution = .fill
        object.spacing = 4
        return object
    }()
    
    let priorityImageView: UIImageView = {
       let object = UIImageView()
        object.contentMode = .scaleAspectFit
        object.tintColor = .systemBlue
        return object
    }()
    
    let checkButton: UIButton = {
        let object = UIButton()
        object.setImage(UIImage(systemName: "circle.circle"), for: .selected)
        object.setImage(UIImage(systemName: "circle"), for: .normal)
        object.tintColor = .lightGray
        return object
    }()
    
    let flagImageView: UIImageView = {
        let object = UIImageView()
        object.contentMode = .scaleAspectFit
        object.tintColor = .systemYellow
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
    
    let tagLabel: UILabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 14)
        object.textColor = .systemBlue
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
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(reminderImageView)
        contentStackView.addArrangedSubview(backView)
        backView.addSubview(stackView)
        backView.addSubview(contentLabel)
        backView.addSubview(dateLabel)
        backView.addSubview(tagLabel)
        
        stackView.addArrangedSubview(priorityImageView)
        stackView.addArrangedSubview(titleLabel)
        
        contentView.addSubview(flagImageView)
        
        
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        checkButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
            make.size.equalTo(30)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.leading.equalTo(checkButton.snp.trailing).offset(8)
            make.verticalEdges.equalToSuperview().inset(8)
            make.trailing.equalTo(flagImageView.snp.leading).offset(-8)
        }
        
        reminderImageView.snp.makeConstraints { make in
            make.width.equalTo(contentView.snp.height).multipliedBy(0.7)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.height.equalTo(16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.height.equalTo(16)
        }
        
        tagLabel.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel.snp.trailing).offset(8)
            make.top.equalTo(dateLabel.snp.top)
        }
        
        flagImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.top.equalTo(backView.snp.top)
            make.size.equalTo(30)
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    public func fetchData(_ item: Reminder, image: UIImage?){
        
        titleLabel.attributedText = item.isComplete ? item.title.strikeThrough() : NSAttributedString(string: item.title)
        contentLabel.text = item.content
        dateLabel.text = item.formattedDate
        checkButton.isSelected = item.isComplete
        tagLabel.text = item.hashTaggedString
        flagImageView.image = item.isFlag ? UIImage(systemName: "flag.fill") : UIImage(systemName: "flag")
        
        if image != nil {
            reminderImageView.image = image
            reminderImageView.isHidden = false
        } else {
            reminderImageView.isHidden = true
        }
        
        
        if let priority = item.prioirty {
            priorityImageView.isHidden = false
            switch priority {
            case 1:
                priorityImageView.image = UIImage(systemName: "exclamationmark")
            case 2:
                priorityImageView.image = UIImage(systemName: "exclamationmark.2")
            case 3:
                priorityImageView.image = UIImage(systemName: "exclamationmark.3")
            default:
                priorityImageView.image = nil
            }
        } else {
            priorityImageView.isHidden = true
        }
    }
}
