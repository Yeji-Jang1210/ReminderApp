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
    
    lazy var searchBar: UISearchBar = {
        let object = UISearchBar()
        object.placeholder = "제목으로 검색하세요"
        object.delegate = self
        return object
    }()
    
    let tableView: UITableView = {
        let object = UITableView()
        object.backgroundColor = .clear
        return object
    }()
    
    var repository = ReminderRepository()
    var category: Category!
    var list: Results<Reminder>!
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
        filteredList = list
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        configureNavigationBar()
        configureTableView()
    }
    
    private func configureNavigationBar(){
        navigationItem.title = category.title
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : category.tintColor]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
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
        repository.updateComplete(item: list[sender.tag])
        
        tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
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
        let item = filteredList[indexPath.row]
        cell.fetchData(item, image: loadImageToDocument(filename: item.id.stringValue))
        cell.checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        cell.checkButton.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "삭제") { [self] (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            
            let data =  list[indexPath.row]
            removeImageFromDocument(filename: list[indexPath.row].id.stringValue)
            repository.deleteItem(item: data)
            tableView.reloadData()
            success(true)
        }
        delete.backgroundColor = .systemRed
        
        let flag = UIContextualAction(style: .normal, title: "깃발") { [self] (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            
            repository.updateFlag(item: list[indexPath.row])
            tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
            success(true)
        }
        flag.backgroundColor = .systemYellow
        return UISwipeActionsConfiguration(actions:[delete, flag])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailReminderInfoVC()
        vc.reminder = list?[indexPath.row]
        present(vc, animated: true)
    }
}

extension ListReminderVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filtered = list.where {
            $0.title.contains(searchText, options: .caseInsensitive)
        }
        
        filteredList = searchText.isEmpty ? list : filtered
        tableView.reloadData()
    }
}
