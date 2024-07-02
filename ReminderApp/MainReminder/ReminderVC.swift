//
//  ReminderVC.swift
//  ReminderApp
//
//  Created by 장예지 on 7/2/24.
//

import UIKit
import SnapKit

final class ReminderVC: BaseVC {
    
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
        view.addSubview(addReminderButton)
        view.addSubview(addCategoryButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
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
        
        addReminderButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    private func configureNavigationBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "전체"
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.lightGray.cgColor]
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(rightBarButtonTapped))
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

