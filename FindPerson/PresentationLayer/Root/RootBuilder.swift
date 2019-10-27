//
//  RootBuilder.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 23/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import UIKit

internal protocol RootBuildable {
    func build(withModuleOutput output: RootModuleOutput?) -> UIViewController & RootModuleInput
}

internal protocol RootDependency {
    var peopleService: PeopleService { get }
    var realmService: RealmService { get }
}

internal class RootDependencyContainer: PeopleListDependency, PeopleDetailDependency {

    // MARK: - Properties

    let dependency: RootDependency

    // MARK: - Init

    init(dependency: RootDependency) {
        self.dependency = dependency
    }
    
    var peopleService: PeopleService {
        return dependency.peopleService
    }
    
    var realmService: RealmService {
        return dependency.realmService
    }

}

private struct Builders: RootModuleBuilders {
    var peopleList: PeopleListBuildable
    var peopleDetail: PeopleDetailBuildable
}

internal class RootBuilder: RootBuildable {

    // MARK: - Properties

    let dependency: RootDependency

    // MARK: - Init

    init(dependency: RootDependency) {
        self.dependency = dependency
    }

    // MARK: - RootBuildable
    
    func build(withModuleOutput output: RootModuleOutput?) -> UIViewController & RootModuleInput {
        let container = RootDependencyContainer(dependency: dependency)
        let builders = Builders(peopleList: PeopleListBuilder(dependency: container),
                                peopleDetail: PeopleDetailBuilder(dependency: container))
        let viewController = RootViewController(builders: builders)
        let interactor = RootInteractor()
        let presenter = RootPresenter()
        viewController.interactor = interactor
        viewController.moduleOutput = output
        interactor.presenter = presenter
        presenter.viewController = viewController
        return viewController
    }

}
