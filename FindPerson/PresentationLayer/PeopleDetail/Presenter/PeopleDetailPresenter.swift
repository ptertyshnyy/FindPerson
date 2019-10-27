//
//  PeopleDetailPresenter.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 23/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import Foundation

internal protocol PeopleDetailPresentationLogic {
    func presentLoad(response: PeopleDetailDataFlow.Load.Response)
}

internal class PeopleDetailPresenter: PeopleDetailPresentationLogic {

    // MARK: - Properties
    
    weak var viewController: PeopleDetailControllerLogic?

    // MARK: - PeopleDetailPresentationLogic

    func presentLoad(response: PeopleDetailDataFlow.Load.Response) {
        let makeItem = makePeopleItem(people: response.people)
        let viewModel = PeopleDetailDataFlow.Load.ViewModel(
            result: makeItem
        )
        viewController?.displayLoad(viewModel: viewModel)
    }
    
    private func makePeopleItem(people: People) -> PeopleDetailDataFlow.PeopleItem {
        return PeopleDetailDataFlow.PeopleItem(
            name: people.name,
            birthYear: people.birthYear,
            height: people.height,
            mass: people.mass,
            created: people.created.toString(dateFormat: "dd MMMM, yyyy"),
            edited: people.edited.toString(dateFormat: "dd MMMM, yyyy"),
            gender: people.gender?.rawValue
        )
    }

}
