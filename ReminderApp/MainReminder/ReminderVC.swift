//
//  ReminderVC.swift
//  ReminderApp
//
//  Created by 장예지 on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift

final class ReminderVC: BaseVC {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical
        
        let object = UICollectionView(frame: .zero, collectionViewLayout: layout)
        object.backgroundColor = .clear
        return object
    }()
    
    lazy var tableView: UITableView = {
        let object = UITableView(frame: .zero, style: .insetGrouped)
        object.backgroundColor = .clear
        object.delegate = self
        object.dataSource = self
        object.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        return object
    }()
    
    let addReminderButton: UIButton = {
        var configure = UIButton.Configuration.plain()
        configure.title = "새로운 할 일"
        configure.image = UIImage(systemName: "plus.circle.fill")
        configure.imagePadding = 10
        
        let object = UIButton(configuration: configure)
        return object
    }()
    
    let addCategoryButton: UIButton = {
        var configure = UIButton.Configuration.plain()
        configure.title = "목록 추가"
        
        let object = UIButton(configuration: configure)
        return object
    }()
    
    let repository = ReminderRepository()
    lazy var category = repository.fetchCategory()
    lazy var list = repository.fetch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.lightGray.cgColor]
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        //view.addSubview(collectionView)
        view.addSubview(tableView)
        view.addSubview(addReminderButton)
        view.addSubview(addCategoryButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        //        collectionView.snp.makeConstraints { make in
        //            make.top.equalToSuperview()
        //            make.horizontalEdges.equalToSuperview().inset(8)
        //            make.bottom.equalTo(addReminderButton.snp.top).offset(-12)
        //        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(8)
            make.bottom.equalTo(addReminderButton.snp.top).offset(-12)
        }
        
        addReminderButton.snp.makeConstraints { make in
            make.leading.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        addCategoryButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        configureNavigationBar()
        configureCollectionView()
        addReminderButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    private func configureNavigationBar(){
        print(#function)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "전체"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(rightBarButtonTapped))
    }
    
    private func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
    }
    
    @objc
    func rightBarButtonTapped(){
        let vc = CalendarReminderVC()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @objc
    func addButtonTapped(){
        let vc = AddedReminderVC()
        vc.onDismiss = {
            self.collectionView.reloadData()
            self.tableView.reloadData()
        }
        
        let nvc = UINavigationController(rootViewController: vc)
        present(nvc, animated: true)
    }
}

extension ReminderVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Filter.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as! FilterCollectionViewCell
        if let filter = Filter(rawValue: indexPath.row) {
            cell.setData(filter, count: repository.fetchForFilteredValue(filter).count)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2 - 10
        return CGSize(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let filter = Filter(rawValue: indexPath.row) {
            let vc = ListReminderVC()
            vc.filter = filter
            vc.list = repository.fetchForFilteredValue(filter)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ReminderVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return collectionView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as! CategoryTableViewCell
        let data = category[indexPath.row]
        cell.setTitle(title: data.name)
        cell.detailTextLabel?.text = "\(data.list.count)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ListReminderVC()
        vc.list = list.where{$0.category.name == category[indexPath.row].name }
        vc.navigationItem.title = category[indexPath.row].name
        navigationController?.pushViewController(vc, animated: true)
    }
}
