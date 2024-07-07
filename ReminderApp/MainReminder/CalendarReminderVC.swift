//
//  CalendarReminderVC.swift
//  ReminderApp
//
//  Created by 장예지 on 7/7/24.
//

import UIKit
import RealmSwift
import SnapKit
import FSCalendar

class CalendarReminderVC: BaseVC {
    //MARK: - object
    lazy var dismissButton: UIButton = {
        let object = UIButton()
        object.setImage(UIImage(systemName: "xmark"), for: .normal)
        object.tintColor = .label
        object.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        return object
    }()
    
    lazy var calendar: FSCalendar = {
        let object = FSCalendar()
        object.dataSource = self
        object.delegate = self
        object.locale = Locale(identifier: "ko_KR")
        object.scrollDirection = .horizontal
        
        //header
        object.headerHeight = 60
        object.appearance.headerMinimumDissolvedAlpha = 0.0
        object.appearance.headerTitleFont = .systemFont(ofSize: 20, weight: .bold)
        
        //date
        object.appearance.weekdayTextColor = UIColor.label
        object.appearance.titleDefaultColor = UIColor.label
        object.appearance.todayColor = UIColor.label
        object.allowsMultipleSelection = false
        return object
    }()
    
    lazy var tableView: UITableView = {
        let object = UITableView()
        object.delegate = self
        object.dataSource = self
        object.allowsSelection = false
        object.separatorStyle = .none
        object.register(ReminderTableViewCell.self, forCellReuseIdentifier: ReminderTableViewCell.identifier)
        return object
    }()
    
    //MARK: - properties
    var repository = ReminderRepository()
    lazy var filteredList = repository.fetchFilterForDate()
    var calendarHeightConstraint: Constraint!
    lazy var events: [Date] = repository.fetch().filter{$0.deadline != nil}.map{ $0.deadline! }
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    //MARK: - configure function
    override func configureHierarchy(){
        super.configureHierarchy()
        view.addSubview(dismissButton)
        view.addSubview(calendar)
        view.addSubview(tableView)
    }
    
    override func configureLayout(){
        super.configureLayout()
        dismissButton.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.size.equalTo(24)
        }
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(dismissButton.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            self.calendarHeightConstraint = make.height.equalTo(400).constraint
        }
        
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(calendar.snp.bottom).offset(20)
        }
    }
    
    override func configureUI(){
        super.configureUI()
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    //MARK: - function
    @objc
    func dismissButtonTapped(){
        dismiss(animated: true)
    }
    
    @objc
    func swipeEvent(_ swipe: UISwipeGestureRecognizer) {
        print(#function)
        
        if swipe.direction == .up {
            calendar.scope = .week
        }
        else if swipe.direction == .down {
            calendar.scope = .month
        }
    }
}

extension CalendarReminderVC: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return UIColor.label
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return .label
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]?{
        return [UIColor.label]
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if events.contains(where:{ $0.isSameDay(as: date)}) {
            return 1
        } else {
            return 0
        }
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.update(offset: bounds.height)
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        filteredList = repository.fetchFilterForDate(date)
        tableView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return false
    }
}

extension CalendarReminderVC: UITableViewDelegate, UITableViewDataSource {
    
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
        return cell
    }
}
