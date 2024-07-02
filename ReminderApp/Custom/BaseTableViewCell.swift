//
//  BaseTableViewCell.swift
//  ReminderApp
//
//  Created by 장예지 on 7/2/24.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(named: "cellBackground")
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy(){}
    func configureLayout(){}
    func configureUI(){}
}
