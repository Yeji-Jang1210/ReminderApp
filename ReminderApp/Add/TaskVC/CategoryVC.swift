//
//  CategoryVC.swift
//  ReminderApp
//
//  Created by 장예지 on 7/8/24.
//

import UIKit
import SnapKit

class CategoryVC: BaseVC {
    lazy var tableView: UITableView = {
        let object = UITableView(frame: .zero, style: .insetGrouped)
        object.backgroundColor = .clear
        object.delegate = self
        object.dataSource = self
        object.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        return object
    }()
    
    let repository = ReminderRepository()
    lazy var category = repository.fetchCategory()
    var delegate: PassDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    public func setData(_ category: Category?){
        guard let category = category, let index = repository.findCategoryIndex(category) else { return }
        
        tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .middle)
    }
}

extension CategoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as! CategoryTableViewCell
        cell.setTitle(title: category[indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.passCategory(category[indexPath.row])
    }
}
