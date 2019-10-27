//
//  RootInteractor.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 23/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import Foundation

internal protocol RootBusinessLogic {
    func load(request: RootDataFlow.Load.Request)
}

internal class RootInteractor: RootBusinessLogic {

    // MARK: - Properties

    var presenter: RootPresentationLogic?
    
    // MARK: - RootBusinessLogic

    func load(request: RootDataFlow.Load.Request) {
        let response = RootDataFlow.Load.Response()
        presenter?.presentLoad(response: response)
    }

}
