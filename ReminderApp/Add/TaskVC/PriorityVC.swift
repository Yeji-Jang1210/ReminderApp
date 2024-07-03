//
//  PriorityVC.swift
//  ReminderApp
//
//  Created by 장예지 on 7/3/24.
//

import UIKit
import SnapKit

enum Priority: Int, CaseIterable {
    case high
    case normal
    case low
    
    var title: String {
        switch self {
        case .high:
            return "높음"
        case .normal:
            return "보통"
        case .low:
            return "낮음"
        }
    }
}

class PriorityVC: BaseVC {
    
    let segmentedControl: UISegmentedControl = {
        let object = UISegmentedControl()
        for item in Priority.allCases {
            object.insertSegment(withTitle: item.title, at: item.rawValue, animated: true)
        }
        return object
    }()
    
    var delegate: PassDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.passPriorityValue(Priority(rawValue: segmentedControl.selectedSegmentIndex) ?? .normal)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubview(segmentedControl)
    }
    
    override func configureLayout() {
        super.configureLayout()
        segmentedControl.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    public func setData(_ priority: Priority?){
        segmentedControl.selectedSegmentIndex = priority?.rawValue ?? 1
    }
}
