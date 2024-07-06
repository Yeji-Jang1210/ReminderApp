//
//  ReminderImageVC.swift
//  ReminderApp
//
//  Created by 장예지 on 7/7/24.
//

import UIKit
import PhotosUI
import SnapKit

class ReminderImageVC: BaseVC {
    
    let imageView: UIImageView = {
        let object = UIImageView()
        object.contentMode = .scaleAspectFill
        object.clipsToBounds = true
        object.layer.cornerRadius = 12
        object.backgroundColor = .lightGray
        return object
    }()
    
    lazy var deleteButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.background.backgroundColor = UIColor(named: "cellBackground")
        config.attributedTitle = AttributedString("이미지 삭제",
                                                  attributes: AttributeContainer([.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 14)]))
        
        let object = UIButton(configuration: config)
        object.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return object
    }()
    
    var delegate: PassDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "photo.badge.plus"), style: .plain, target: self, action: #selector(addButtonTapped))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.passImageValue(imageView.image)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubview(imageView)
        view.addSubview(deleteButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(imageView.snp.width).multipliedBy(1.4)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    @objc
    func addButtonTapped(){
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc
    func deleteButtonTapped(){
        imageView.image = nil
    }
    
    public func setData(_ image: UIImage?){
        imageView.image = image
    }
}

extension ReminderImageVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        self.dismiss(animated: true)
        
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    self.imageView.image = image as? UIImage
                }
            }
        }
    }
}
