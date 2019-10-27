//
//  PeopleDetailBuilder.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 23/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import UIKit

internal protocol PeopleDetailBuildable {
    func build(withModuleOutput output: PeopleDetailModuleOutput, people: People) -> UIViewController & PeopleDetailModuleInput
}

internal protocol PeopleDetailDependency {

}

internal class PeopleDetailDependencyContainer {

    // MARK: - Properties

    let dependency: PeopleDetailDependency

    // MARK: - Init

    init(dependency: PeopleDetailDependency) {
        self.dependency = dependency
    }

}

internal class PeopleDetailBuilder: PeopleDetailBuildable {

    // MARK: - Properties

    let dependency: PeopleDetailDependency

    // MARK: - Init

    init(dependency: PeopleDetailDependency) {
        self.dependency = dependency
    }

    // MARK: - PeopleDetailBuildable
    
    func build(withModuleOutput output: PeopleDetailModuleOutput, people: People) -> UIViewController & PeopleDetailModuleInput {
        let viewController = PeopleDetailViewController()
        let interactor = PeopleDetailInteractor(people: people)
        let presenter = PeopleDetailPresenter()
        viewController.interactor = interactor
        viewController.moduleOutput = output
        interactor.presenter = presenter
        presenter.viewController = viewController
        return viewController
    }

}
