//
//  PeopleListDataManager.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 24/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import UIKit

internal class PeopleListDataManager: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    var items: [PeopleListDataFlow.Item] = []
    
    var onSelectPeople: ((Int) -> Void)?
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.item]
        
        switch item {
        case .message(let title):
            let cell = tableView.dequeueReusableCell(withClass: PeopleInfoCell.self, forIndexPath: indexPath)
            cell.setupTitle(title)
            return cell
        case .people(let people):
            let cell = tableView.dequeueReusableCell(withClass: PeopleCell.self, forIndexPath: indexPath)
            cell.setupCell(people)
            return cell
        case .loading:
            let cell = tableView.dequeueReusableCell(withClass: PeopleActivityCell.self, forIndexPath: indexPath)
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = items[indexPath.item]
        
        switch item {
        case .message, .loading:
            return 64.0
        case .people:
            return 100.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = items[indexPath.item]
        
        if case .people = item {
            onSelectPeople?(indexPath.row)
        }
    }

}
