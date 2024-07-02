//
//  AddedReminderVC.swift
//  ReminderApp
//
//  Created by 장예지 on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift
import Toast

final class AddedReminderVC: BaseVC {
    
    enum SectionType: Int, CaseIterable {
        case deadLine
        case tag
        case priority
        case image
        
        var title: String {
            switch self {
            case .deadLine:
                return "마감일"
            case .tag:
                return "태그"
            case .priority:
                return "우선순위"
            case .image:
                return "이미지 추가"
            }
        }
    }
    
    let backView: UIView = {
        let object = UIView()
        object.clipsToBounds = true
        object.layer.cornerRadius = 8
        object.backgroundColor = UIColor(named: "cellBackground")
        return object
    }()
    
    let titleTextField: UITextField = {
        let object = UITextField()
        object.placeholder = "제목"
        object.font = .systemFont(ofSize: 12)
        return object
    }()
    
    let seperatorView: UIView = {
        let object = UIView()
        object.backgroundColor = .systemGray5
        return object
    }()
    
    let contentTextViewPlaceholder: UILabel = {
        let object = UILabel()
        object.text = "메모"
        object.textColor = .systemGray
        object.font = .systemFont(ofSize: 12)
        return object
    }()
    
    let contentTextView: UITextView = {
        let object = UITextView()
        object.backgroundColor = .clear
        return object
    }()
    
    let tableView: UITableView = {
        let object = UITableView(frame: .zero, style: .insetGrouped)
        object.backgroundColor = .clear
        return object
    }()
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        view.addSubview(backView)
        view.addSubview(tableView)
        
        backView.addSubview(titleTextField)
        backView.addSubview(seperatorView)
        backView.addSubview(contentTextView)
        backView.addSubview(contentTextViewPlaceholder)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        backView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(20)
        }
        
        seperatorView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(0.5)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(seperatorView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(seperatorView)
            make.bottom.equalToSuperview()
            make.height.equalTo(120)
        }
        
        contentTextViewPlaceholder.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentTextView).inset(8)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        configureNavigationBar()
        configureTableView()
        titleTextField.addTarget(self, action: #selector(titleTextChanged), for: .editingChanged)
        contentTextView.delegate = self
    }
    
    private func configureNavigationBar(){
        navigationItem.title = "새로운 할 일"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(dismissButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
    }
    
    @objc
    func dismissButtonTapped(){
        dismiss(animated: true)
    }
    
    @objc
    func addButtonTapped(){
        guard let text = titleTextField.text, !text.isEmpty else {
            showAlert(title: "오류", message: "제목을 입력해주세요", ok: "확인"){ }
            return
        }
        
        let reminder = Reminder(title: text, content: contentTextView.text)
        
        //default.realm에 레코드 추가
        do {
            try realm.write {
                realm.add(reminder)
            }
            dismiss(animated: true)
        } catch {
            showAlert(title: "오류", message: "저장하는데 오류가 생겼습니다.", ok: "확인"){ }
        }
    }
    
    @objc
    func titleTextChanged(){
        guard let text = titleTextField.text else {
            navigationItem.rightBarButtonItem?.isEnabled = false
            return
        }
        
        navigationItem.rightBarButtonItem?.isEnabled = text.isEmpty ? false : true
    }
}

extension AddedReminderVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
        
        guard let title = SectionType(rawValue: indexPath.section)?.title else {
            return cell
        }
        
        cell.setTitle(title: title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            //마감일 VC 띄우기
        }
    }
    
}

extension AddedReminderVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text, !text.isEmpty {
            contentTextViewPlaceholder.isHidden = true
        } else {
            contentTextViewPlaceholder.isHidden = false
        }
    }
}
