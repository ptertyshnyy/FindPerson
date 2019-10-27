//
//  PeopleListBuilder.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 23/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import UIKit

internal protocol PeopleListBuildable {
    func build(withModuleOutput output: PeopleListModuleOutput) -> UIViewController & PeopleListModuleInput
}

internal protocol PeopleListDependency {
    var peopleService: PeopleService { get }
    var realmService: RealmService { get }
}

internal class PeopleListDependencyContainer {

    // MARK: - Properties

    let dependency: PeopleListDependency

    // MARK: - Init

    init(dependency: PeopleListDependency) {
        self.dependency = dependency
    }

}

internal class PeopleListBuilder: PeopleListBuildable {

    // MARK: - Properties

    let dependency: PeopleListDependency

    // MARK: - Init

    init(dependency: PeopleListDependency) {
        self.dependency = dependency
    }

    // MARK: - PeopleListBuildable
    
    func build(withModuleOutput output: PeopleListModuleOutput) -> UIViewController & PeopleListModuleInput {
        let viewController = PeopleListViewController()
        let interactor = PeopleListInteractor(peopleService: dependency.peopleService,
                                              realmService: dependency.realmService)
        let presenter = PeopleListPresenter()
        viewController.interactor = interactor
        viewController.moduleOutput = output
        interactor.presenter = presenter
        presenter.viewController = viewController
        return viewController
    }

}
