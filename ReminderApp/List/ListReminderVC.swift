//
//  ListReminderVC.swift
//  ReminderApp
//
//  Created by 장예지 on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift

class ListReminderVC: BaseVC {
    
    enum FilterType: CaseIterable {
        case deadline
        case title
        
        var title: String {
            switch self {
            case .deadline:
                return "마감일 순으로 보기"
            case .title:
                return "제목 순으로 보기"
            }
        }
        
        var keyPath: String {
            switch self {
            case .deadline:
                return "deadline"
            case .title:
                return "title"
            }
        }
    }
    
    let tableView: UITableView = {
        let object = UITableView()
        object.backgroundColor = .clear
        return object
    }()
    
    let realm = try! Realm()
    lazy var list = realm.objects(Reminder.self)
    
    var filteredList: Results<Reminder>!
    
    var filterType: FilterType? {
        didSet {
            if let type = filterType {
                filteredList = list.sorted(byKeyPath: type.keyPath, ascending: true)
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list = realm.objects(Reminder.self)
        filteredList = list
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
    
    override func configureUI() {
        super.configureUI()
        configureNavigationBar()
        configureTableView()
    }
    
    private func configureNavigationBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "전체"
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.systemBlue.cgColor]
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(rightBarButtonTapped))
    }
    
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(ReminderTableViewCell.self, forCellReuseIdentifier: ReminderTableViewCell.identifier)
    }
    
    @objc
    func rightBarButtonTapped(){
        let alert = UIAlertController(title: "필터링", message: "", preferredStyle: .actionSheet)
        
        var actionList: [UIAlertAction] = []
        
        for filter in FilterType.allCases {
            let action = UIAlertAction(title: filter.title, style: .default) { _ in
                self.filterType = filter
            }
            actionList.append(action)
        }
        
        actionList.append(UIAlertAction(title: "취소", style: .cancel))
        
        actionList.map { alert.addAction($0) }
        
        present(alert, animated: true)
    }
    
    @objc
    func checkButtonTapped(_ sender: UIButton){
        sender.isSelected.toggle()
    }
}

extension ListReminderVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReminderTableViewCell.identifier, for: indexPath) as! ReminderTableViewCell
        cell.fetchData(filteredList[indexPath.row])
        cell.checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        cell.checkButton.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "삭제") { [self] (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            
            try! self.realm.write {
                realm.delete(self.filteredList[indexPath.row])
            }
            tableView.reloadData()
            success(true)
        }
        delete.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions:[delete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailReminderInfoVC()
        vc.reminder = list[indexPath.row]
        present(vc, animated: true)
    }
}
