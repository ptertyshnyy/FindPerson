//
//  PeopleListView.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 23/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import UIKit
import SnapKit

internal protocol PeopleListViewDelegate: class {

}

internal class PeopleListView: UIView {

    // MARK: - Properties

    weak var delegate: PeopleListViewDelegate?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 8.0, right: 0.0)
        tableView.register(cellClass: PeopleCell.self)
        tableView.register(cellClass: PeopleInfoCell.self)
        tableView.register(cellClass: PeopleActivityCell.self)
        
        return tableView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(tableView)
        
        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupLoad(viewModel: PeopleListDataFlow.Load.ViewModel) {
        
    }
    
    func setupDataManager(dataManager: UITableViewDataSource & UITableViewDelegate) {
        tableView.dataSource = dataManager
        tableView.delegate = dataManager
        tableView.reloadData()
    }
    
    // MARK: - Layout
    
    private func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
