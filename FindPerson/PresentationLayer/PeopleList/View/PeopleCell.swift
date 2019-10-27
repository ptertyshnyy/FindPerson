//
//  PeopleCell.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 24/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import UIKit

internal class PeopleCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let peopleInputView: InputView = {
        let view = InputView()
        view.layer.cornerRadius = 8.0
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 2
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = .lightGray
        label.textAlignment = .left
        
        return label
    }()
    
    private let infoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "infoIcon").withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .lightGray
        
        return imageView
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(peopleInputView)
        peopleInputView.addSubview(titleLabel)
        peopleInputView.addSubview(dateLabel)
        peopleInputView.addSubview(infoImage)
        
        makeCostraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupCell(_ item: PeopleListDataFlow.PeopleModel) {
        titleLabel.text = item.title
        dateLabel.text = item.created
    }
    
    // MARK: - Layout
    
    private func makeCostraints() {
        peopleInputView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8.0)
            make.left.right.equalToSuperview().inset(16.0)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        infoImage.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(12.0)
            make.width.height.equalTo(24.0)
            make.bottom.equalToSuperview().offset(-6.0)
        }
        dateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(12.0)
            make.right.equalTo(infoImage.snp.left).inset(12.0)
            make.bottom.equalToSuperview().offset(-12.0)
        }
    }
}

