//
//  PeopleDetailDataFlow.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 23/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import Foundation

internal enum PeopleDetailDataFlow {
    
    enum Load {

        struct Request { }

        struct Response {
            let people: People
        }

        struct ViewModel {
            let result: PeopleItem
        }
        
    }
    
    struct PeopleItem {
        let name: String
        let birthYear: String
        let height: String
        let mass: String
        let created: String
        let edited: String
        let gender: String?
    }
    
}
