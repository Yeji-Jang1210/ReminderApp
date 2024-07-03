//
//  DetailReminderInfoVC.swift
//  ReminderApp
//
//  Created by 장예지 on 7/3/24.
//

import UIKit
import SnapKit
import RealmSwift

class DetailReminderInfoVC: BaseVC {
    
    let titleLabel: UILabel = {
        let object = UILabel()
        object.font = .boldSystemFont(ofSize: 20)
        return object
    }()
    
    let tagLabel: UILabel = {
        let object = UILabel()
        object.font = .boldSystemFont(ofSize: 14)
        object.textColor = .lightGray
        return object
    }()
    
    let deadLineLabel: UILabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 14)
        object.textColor = .lightGray
        object.textAlignment = .left
        return object
    }()
    
    let contentBackView: UIView = {
        let object = UIView()
        object.backgroundColor = UIColor(named: "cellBackground")
        object.clipsToBounds = true
        object.layer.cornerRadius = 8
        return object
    }()
    
    let contentImageView: UIImageView = {
        let object = UIImageView()
        object.image = UIImage(systemName: "checkmark")
        object.contentMode = .scaleAspectFit
        return object
    }()
    
    let contentTextView: UITextView = {
        let object = UITextView()
        object.isEditable = false
        object.backgroundColor = .clear
        object.font = .systemFont(ofSize: 12)
        return object
    }()
    
    var reminder: Reminder? {
        didSet {
            guard let reminder else {
                showAlert(title: "오류", message: "데이터를 불러오는데 오류가 발생했습니다.") {
                    self.dismiss(animated: true)
                }
                return
            }
            titleLabel.text = reminder.title
            tagLabel.text = reminder.hashTaggedString
            deadLineLabel.text = reminder.formattedDate
            if let isEmpty = reminder.content?.isEmpty {
                contentTextView.text = isEmpty ? "내용이 비어있습니다." : reminder.content
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubview(titleLabel)
        view.addSubview(tagLabel)
        view.addSubview(deadLineLabel)
        view.addSubview(contentBackView)
        
        contentBackView.addSubview(contentImageView)
        contentBackView.addSubview(contentTextView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        deadLineLabel.snp.makeConstraints { make in
            make.leading.equalTo(tagLabel.snp.trailing).offset(8)
            make.centerY.equalTo(tagLabel.snp.centerY)
        }
        
        contentBackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(tagLabel.snp.bottom).offset(20)
            make.height.greaterThanOrEqualTo(50)
        }
        
        contentImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.top.leading.equalToSuperview().offset(8)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(8)
            make.leading.equalTo(contentImageView.snp.trailing).offset(8)
        }
    }
}
