//
//  DeadLinePickerVC.swift
//  ReminderApp
//
//  Created by 장예지 on 7/3/24.
//

import UIKit
import SnapKit

final class DeadLinePickerVC: BaseVC {
    let datePicker: UIDatePicker = {
        let object = UIDatePicker()
        object.locale = Locale(identifier: "ko-KR")
        object.date = Date()
        object.preferredDatePickerStyle = .wheels
        
        return object
    }()
    
    var delegate: PassDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "마감일"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.passDateValue(datePicker.date)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubview(datePicker)
    }
    
    override func configureLayout() {
        super.configureLayout()
        datePicker.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    public func setData(_ date: Date?){
        datePicker.date = date ?? .now
    }
}
