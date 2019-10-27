//
//  PeopleDetailViewController.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 23/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import UIKit

internal protocol PeopleDetailControllerLogic: class {
    func displayLoad(viewModel: PeopleDetailDataFlow.Load.ViewModel)
}

internal protocol PeopleDetailModuleOutput: class {

}

internal protocol PeopleDetailModuleInput: class {

}

internal class PeopleDetailViewController: UIViewController,
    PeopleDetailControllerLogic, PeopleDetailModuleInput, PeopleDetailViewDelegate {

    // MARK: - Properties

    var interactor: PeopleDetailBusinessLogic?

    weak var moduleOutput: PeopleDetailModuleOutput?

    var moduleView: PeopleDetailView!

    // MARK: - View life cycle

    override func loadView() {
        moduleView = PeopleDetailView(frame: UIScreen.main.bounds)
        moduleView.delegate = self
        view = moduleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startLoading()
    }

    // MARK: - PeopleDetailControllerLogic

    private func startLoading() {
        let request = PeopleDetailDataFlow.Load.Request()
        interactor?.load(request: request)
    }

    func displayLoad(viewModel: PeopleDetailDataFlow.Load.ViewModel) {
        moduleView.setupLoad(viewModel: viewModel)
    }

}
