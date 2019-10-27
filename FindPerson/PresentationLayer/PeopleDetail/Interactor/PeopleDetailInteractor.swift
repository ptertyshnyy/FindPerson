//
//  PeopleDetailInteractor.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 23/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import Foundation

internal protocol PeopleDetailBusinessLogic {
    func load(request: PeopleDetailDataFlow.Load.Request)
}

internal class PeopleDetailInteractor: PeopleDetailBusinessLogic {

    // MARK: - Properties
    
    private var people: People

    var presenter: PeopleDetailPresentationLogic?
    
    // MARK: - Init
    
    init(people: People) {
        self.people = people
    }
    
    // MARK: - PeopleDetailBusinessLogic

    func load(request: PeopleDetailDataFlow.Load.Request) {
        let response = PeopleDetailDataFlow.Load.Response(people: people)
        presenter?.presentLoad(response: response)
    }

}
