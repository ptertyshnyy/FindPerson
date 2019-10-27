//
//  PeopleListSearchController.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 24/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

internal class PeopleListSearchController: UISearchController {
    
    // MARK: - Properties
    
    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    private let disposeBag = DisposeBag()

    var onPeopleSearch: ((String) -> Void)?
    var onCancelClicked: (() -> Void)?
    
    // MARK: - Init
    
    init() {
        super.init(searchResultsController: nil)

        obscuresBackgroundDuringPresentation = false
        searchBar.delegate = self
        
        searchBar.addSubview(activityIndicator)
        
        setupSearchBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupSearchBar() {
        searchBar.tintColor = .gray
        searchBar.placeholder = "Поиск"
        
        searchBar.rx.text
        .orEmpty
        .filter { query in
          return query.count > 2
        }.debounce(.milliseconds(500), scheduler: MainScheduler.instance)
        .subscribe(onNext: { [weak self] name in
            self?.onPeopleSearch?(name)
        })
        .disposed(by: disposeBag)
    }

}

extension PeopleListSearchController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        onCancelClicked?()
    }
}
