//
//  PeopleListInteractor.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 23/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import Foundation

internal protocol PeopleListBusinessLogic {
    func load(request: PeopleListDataFlow.Load.Request)
    func nameInput(request: PeopleListDataFlow.NameInput.Request)
    func selectPeople(request: PeopleListDataFlow.SelectPeople.Request)
    func updateStatus(request: PeopleListDataFlow.UpdateStatus.Request)
}

internal class PeopleListInteractor: PeopleListBusinessLogic {

    // MARK: - Properties

    private var peopleList: [People] = []
    
    private let peopleService: PeopleService
    private let realmService: RealmService
    
    var presenter: PeopleListPresentationLogic?
    
    // MARK: - Init
    
    init(peopleService: PeopleService, realmService: RealmService) {
        self.peopleService = peopleService
        self.realmService = realmService
    }
    
    // MARK: - PeopleListBusinessLogic

    func load(request: PeopleListDataFlow.Load.Request) {
        let response = PeopleListDataFlow.Load.Response()
        presenter?.presentLoad(response: response)
    }
    
    func nameInput(request: PeopleListDataFlow.NameInput.Request) {
        peopleService.getPeopleList(name: request.name) { [weak self] result in
            switch result {
            case .success(let people):
                self?.realmService.createPeople(people: people) { result in
                    let response: PeopleListDataFlow.NameInput.Response
                    
                    switch result {
                    case .success:
                        self?.peopleList = people
                        response = .success(people: people)
                    case .failure(let error):
                        response = .failure(error: error)
                    }
                    self?.presenter?.presentNameInput(response: response)
                }
            case .failure(let error):
                if case .network = error {
                    self?.realmService.fetchPeople(name: request.name) { people in
                        self?.peopleList = people
                        let response: PeopleListDataFlow.NameInput.Response = .success(people: people)
                        self?.presenter?.presentNameInput(response: response)
                    }
                } else {
                    let response: PeopleListDataFlow.NameInput.Response = .failure(error: error)
                    self?.presenter?.presentNameInput(response: response)
                }
            }
        }

        let response = PeopleListDataFlow.LoadingPeople.Response()
        presenter?.presentLoadingPeople(response: response)
    }

    func selectPeople(request: PeopleListDataFlow.SelectPeople.Request) {
        let people = peopleList[request.index]
        let response = PeopleListDataFlow.SelectPeople.Response(people: people)
        presenter?.presentSelectPeople(response: response)
    }
    
    func updateStatus(request: PeopleListDataFlow.UpdateStatus.Request) {
        if peopleList.isEmpty {
            let response = PeopleListDataFlow.UpdateStatus.Response()
            presenter?.presentUpdateStatus(response: response)
        }
    }
    
}
