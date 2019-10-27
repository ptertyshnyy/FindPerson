//
//  AppDependency.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 23/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import Foundation
import Moya

internal class AppDependency: RootDependency {

    private(set) lazy var peopleProvider: MoyaProvider<API.People> = MoyaProvider<API.People>()
    
    private(set) lazy var peopleService: PeopleService = PeopleServiceImpl(provider: peopleProvider)
    
    private(set) lazy var realmService: RealmService = RealmServiceImpl()
}
