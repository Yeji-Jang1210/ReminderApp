//
//  BaseVC.swift
//  ReminderApp
//
//  Created by 장예지 on 7/2/24.
//

import UIKit

class BaseVC: UIViewController {
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    //MARK: - configure function
    func configureHierarchy(){
        
    }
    
    func configureLayout(){
        
    }
    
    func configureUI(){
        view.backgroundColor = .systemBackground
    }
    
    func showAlert(title: String,message: String, ok: String? = nil, cancel: String? = nil, handler: @escaping (() -> Void)) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let ok = ok {
            let ok = UIAlertAction(title: ok, style: .default) { _ in
                handler()
            }
            alert.addAction(ok)
        }
        
        if let cancel = cancel {
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            
            
            alert.addAction(cancel)
        }
        
        present(alert, animated: true)
    }
    
}
