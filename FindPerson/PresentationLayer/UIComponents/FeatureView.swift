//
//  FeatureView.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 25/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import UIKit

internal class FeatureView: UIView {
    
    // MARK: - Init
    
    private let titleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "infoIcon").withRenderingMode(.alwaysTemplate)
        
        return imageView
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textAlignment = .left
        label.textColor = .black
        label.alpha = 0.5
        
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.textAlignment = .left
        label.textColor = .black
        
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        addSubview(titleImage)
        addSubview(categoryLabel)
        addSubview(valueLabel)
        
        makeCostraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupFeature(icon: UIImage, category: String, value: String) {
        titleImage.image = icon
        categoryLabel.text = category
        valueLabel.text = value
    }
    
    // MARK: - Layout
    
    private func makeCostraints() {
        titleImage.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16.0)
            make.width.height.equalTo(42.0)
        }
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleImage.snp.top)
            make.left.equalTo(titleImage.snp.right).offset(8.0)
            make.right.equalToSuperview()
        }
        valueLabel.snp.makeConstraints { make in
            make.left.equalTo(titleImage.snp.right).offset(8.0)
            make.right.equalToSuperview()
            make.bottom.equalTo(titleImage.snp.bottom)
        }
    }
}
