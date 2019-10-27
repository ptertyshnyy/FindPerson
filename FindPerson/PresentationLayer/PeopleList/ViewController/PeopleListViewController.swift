//
//  PeopleListViewController.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 23/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import UIKit

internal protocol PeopleListControllerLogic: class {
    func displayLoad(viewModel: PeopleListDataFlow.Load.ViewModel)
    func displayNameInput(viewModel: PeopleListDataFlow.NameInput.ViewModel)
    func displayLoadingPeople(viewModel: PeopleListDataFlow.LoadingPeople.ViewModel)
    func displaySelectPeople(viewModel: PeopleListDataFlow.SelectPeople.ViewModel)
    func displayUpdateStatus(viewModel: PeopleListDataFlow.UpdateStatus.ViewModel)
}

internal protocol PeopleListModuleOutput: class {
    func peopleListModuleDidShowPeopleDetail(people: People)
}

internal protocol PeopleListModuleInput: class {

}

internal class PeopleListViewController: UIViewController,
    PeopleListControllerLogic, PeopleListModuleInput, PeopleListViewDelegate {

    // MARK: - Properties

    var interactor: PeopleListBusinessLogic?

    weak var moduleOutput: PeopleListModuleOutput?

    var moduleView: PeopleListView!
    
    private let dataManager: PeopleListDataManager = PeopleListDataManager()
    
    private let searchController: PeopleListSearchController = PeopleListSearchController()

    // MARK: - View life cycle

    override func loadView() {
        moduleView = PeopleListView(frame: UIScreen.main.bounds)
        moduleView.delegate = self
        view = moduleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Поиск персонажа"
        
        searchController.onPeopleSearch = { [weak self] name in
            let request = PeopleListDataFlow.NameInput.Request(name: name)
            self?.interactor?.nameInput(request: request)
        }
        
        searchController.onCancelClicked = { [weak self] in
            let request = PeopleListDataFlow.UpdateStatus.Request()
            self?.interactor?.updateStatus(request: request)
        }

        dataManager.onSelectPeople = { [weak self] index in
            let request = PeopleListDataFlow.SelectPeople.Request(index: index)
            self?.interactor?.selectPeople(request: request)
        }
        
        startLoading()
    }

    // MARK: - PeopleListControllerLogic

    private func startLoading() {
        let request = PeopleListDataFlow.Load.Request()
        interactor?.load(request: request)
    }

    func displayLoad(viewModel: PeopleListDataFlow.Load.ViewModel) {
        moduleView.setupLoad(viewModel: viewModel)
        dataManager.items = viewModel.items
        moduleView.setupDataManager(dataManager: dataManager)
    }
    
    func displayNameInput(viewModel: PeopleListDataFlow.NameInput.ViewModel) {
        switch viewModel {
        case .success(let items):
            dataManager.items = items
            moduleView.setupDataManager(dataManager: dataManager)
        case let .error(title, description):
            let alertController = AlertWindowController.alert(title: title,
                                                              message: description,
                                                              cancel: NSLocalizedString("Ок", comment: ""))
            alertController.show()
            
            let request = PeopleListDataFlow.UpdateStatus.Request()
            self.interactor?.updateStatus(request: request)
        }
    }
    
    func displayLoadingPeople(viewModel: PeopleListDataFlow.LoadingPeople.ViewModel) {
        dataManager.items = viewModel.items
        moduleView.setupDataManager(dataManager: dataManager)
    }
    
    func displaySelectPeople(viewModel: PeopleListDataFlow.SelectPeople.ViewModel) {
        moduleOutput?.peopleListModuleDidShowPeopleDetail(people: viewModel.people)
    }
    
    func displayUpdateStatus(viewModel: PeopleListDataFlow.UpdateStatus.ViewModel) {
        dataManager.items = viewModel.items
        moduleView.setupDataManager(dataManager: dataManager)
    }

}
