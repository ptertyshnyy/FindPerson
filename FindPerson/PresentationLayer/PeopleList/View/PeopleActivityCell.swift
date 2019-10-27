//
//  PeopleActivityCell.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 24/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import UIKit

internal class PeopleActivityCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        makeCostraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        activityIndicatorView.startAnimating()
    }
    
    // MARK: - Layout
    
    private func makeCostraints() {
        activityIndicatorView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        activityIndicatorView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    }
}
