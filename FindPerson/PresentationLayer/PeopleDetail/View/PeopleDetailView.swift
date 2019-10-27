//
//  PeopleDetailView.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 23/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import UIKit

internal protocol PeopleDetailViewDelegate: class {

}

internal class PeopleDetailView: UIView {

    // MARK: - Properties

    weak var delegate: PeopleDetailViewDelegate?
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 2.5
        
        return view
    }()
    
    private let aboutView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8.0
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.textAlignment = .left
        label.textColor = .black
        label.numberOfLines = 2
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textAlignment = .left
        label.textColor = .black
        label.alpha = 0.5
        
        return label
    }()
    
    private let ageFeatureView: FeatureView = FeatureView()
    private let heightFeatureView: FeatureView = FeatureView()
    private let genderFeatureView: FeatureView = FeatureView()
    private let massFeatureView: FeatureView = FeatureView()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(indicatorView)
        addSubview(aboutView)
        aboutView.addSubview(titleLabel)
        aboutView.addSubview(dateLabel)
        aboutView.addSubview(ageFeatureView)
        aboutView.addSubview(heightFeatureView)
        aboutView.addSubview(genderFeatureView)
        aboutView.addSubview(massFeatureView)
        
        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup

    func setupLoad(viewModel: PeopleDetailDataFlow.Load.ViewModel) {
        let people = viewModel.result
        titleLabel.text = people.name
        dateLabel.text = people.created
        ageFeatureView.setupFeature(icon: #imageLiteral(resourceName: "ageIcon"),
                                    category: "Возраст",
                                    value: people.birthYear)
        heightFeatureView.setupFeature(icon: #imageLiteral(resourceName: "heightIcon"),
                                       category: "Рост",
                                       value: people.height)
        genderFeatureView.setupFeature(icon: #imageLiteral(resourceName: "genderIcon"),
                                       category: "Пол",
                                       value: people.gender ?? "")
        massFeatureView.setupFeature(icon: #imageLiteral(resourceName: "massIcon"),
                                     category: "Масса",
                                     value: people.mass)
    }
    
    private func makeConstraints() {
        indicatorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(65.0)
            make.height.equalTo(5.0)
            make.bottom.equalTo(aboutView.snp.top).offset(-8.0)
        }
        aboutView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16.0)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16.0)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().inset(16.0)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview().inset(16.0)
        }
        ageFeatureView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview()
        }
        heightFeatureView.snp.makeConstraints { make in
            make.top.equalTo(ageFeatureView.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview()
        }
        genderFeatureView.snp.makeConstraints { make in
            make.top.equalTo(heightFeatureView.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview()
        }
        massFeatureView.snp.makeConstraints { make in
            make.top.equalTo(genderFeatureView.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16.0)
        }
    }
    
}
