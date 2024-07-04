//
//  ReminderVC.swift
//  ReminderApp
//
//  Created by 장예지 on 7/2/24.
//

import UIKit
import SnapKit

enum Category: Int, CaseIterable {
    case today
    case expected
    case all
    case flag
    case completed
    
    var title: String {
        switch self {
        case .today:
            return "오늘"
        case .expected:
            return "예정"
        case .all:
            return "전체"
        case .flag:
            return "깃발 표시"
        case .completed:
            return "완료됨"
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .today:
            return .systemBlue
        case .expected:
            return .systemRed
        case .all:
            return .systemGray
        case .flag:
            return .systemYellow
        case .completed:
            return .systemGray
        }
    }
    
    var image: UIImage? {
        switch self {
        case .today:
            return UIImage(systemName: "note.text")
        case .expected:
            return UIImage(systemName: "calendar")
        case .all:
            return UIImage(systemName: "tray.fill")
        case .flag:
            return UIImage(systemName: "flag.fill")
        case .completed:
            return UIImage(systemName: "checkmark")
        }
    }
}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubview(collectionView)
        view.addSubview(addReminderButton)
        view.addSubview(addCategoryButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
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
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.lightGray.cgColor]
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(rightBarButtonTapped))
    }
    
    private func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
    }
    
    @objc 
    func rightBarButtonTapped(){
        let vc = ListReminderVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func addButtonTapped(){
        let vc = UINavigationController(rootViewController: AddedReminderVC())
        present(vc, animated: true)
    }
}

extension ReminderVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Category.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        if let category = Category(rawValue: indexPath.row) {
            cell.setData(category, count: 0)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width / 2 - 10
        return CGSize(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            let vc = ListReminderVC()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
