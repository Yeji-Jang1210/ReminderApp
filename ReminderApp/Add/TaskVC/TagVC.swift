//
//  TagVC.swift
//  ReminderApp
//
//  Created by 장예지 on 7/3/24.
//

import UIKit
import SnapKit

class TagVC: BaseVC {
    let tagTextField: UITextField = {
        let object = UITextField()
        object.placeholder = "태그를 입력해 주세요."
        return object
    }()
    
    var delegate: PassDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.passTagValue(tagTextField.text)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubview(tagTextField)
    }
    
    override func configureLayout() {
        super.configureLayout()
        tagTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    public func setData(_ tag: String?){
        tagTextField.text = tag
    }
}
