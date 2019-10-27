//
//  RootPresenter.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 23/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import Foundation

internal protocol RootPresentationLogic {
    func presentLoad(response: RootDataFlow.Load.Response)
}

internal class RootPresenter: RootPresentationLogic {

    // MARK: - Properties
    
    weak var viewController: RootControllerLogic?

    // MARK: - RootPresentationLogic

    func presentLoad(response: RootDataFlow.Load.Response) {
        let viewModel = RootDataFlow.Load.ViewModel()
        viewController?.displayLoad(viewModel: viewModel)
    }

}
