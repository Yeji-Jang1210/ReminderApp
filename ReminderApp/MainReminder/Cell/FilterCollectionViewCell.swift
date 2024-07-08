//
//  FilterCollectionViewCell.swift
//  ReminderApp
//
//  Created by 장예지 on 7/3/24.
//

import UIKit
import SnapKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    let backView: UIView = {
        let object = UIView()
        object.backgroundColor = UIColor(named: "cellBackground")
        object.clipsToBounds = true
        object.layer.cornerRadius = 8
        return object
    }()
    
    let imageBackView: UIView = {
        let object = UIView()
        object.layer.masksToBounds = true
        object.layer.cornerRadius = 18
        return object
    }()
    
    let imageView: UIImageView = {
        let object = UIImageView()
        object.contentMode = .scaleAspectFit
        object.tintColor = .white
        return object
    }()
    
    let titleLabel: UILabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 14)
        object.textColor = .lightGray
        return object
    }()
    
    let remindeCountLabel: UILabel = {
        let object = UILabel()
        object.font = .boldSystemFont(ofSize: 30)
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - configure function
    private func configureHierarchy(){
        contentView.addSubview(backView)
        
        backView.addSubview(imageBackView)
        imageBackView.addSubview(imageView)
        
        backView.addSubview(titleLabel)
        backView.addSubview(remindeCountLabel)
    }
    
    private func configureLayout(){
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageBackView.snp.makeConstraints { make in
            make.size.equalTo(36)
            make.top.leading.equalToSuperview().inset(12)
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(6)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.leading)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        remindeCountLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
        }
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        imageBackView.layer.cornerRadius = imageBackView.bounds.width / 2
//    }
    
    //MARK: - function
    public func setData(_ filter: Filter, count: Int){
        imageBackView.backgroundColor = filter.tintColor
        imageView.image = filter.image
        titleLabel.text = filter.title
        remindeCountLabel.text = String(count)
    }
}
