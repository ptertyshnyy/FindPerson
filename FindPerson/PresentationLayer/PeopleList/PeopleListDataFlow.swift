//
//  PeopleListDataFlow.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 23/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import Foundation

internal enum PeopleListDataFlow {
    
    enum Item {
        case message(title: String)
        case people(people: PeopleModel)
        case loading
    }
    
    struct PeopleModel {
        let title: String
        let created: String
    }
    
    enum Load {

        struct Request { }

        struct Response { }

        struct ViewModel {
            let items: [Item]
        }
        
    }
    
    enum NameInput {

        struct Request {
            let name: String
        }

        enum Response {
            case success(people: [People])
            case failure(error: APIError)
        }

        enum ViewModel {
            case success(items: [Item])
            case error(title: String, description: String)
        }
        
    }
    
    enum LoadingPeople {

        struct Request { }

        struct Response { }

        struct ViewModel {
            let items: [Item]
        }
        
    }
    
    enum SelectPeople {
        
        struct Request {
            let index: Int
        }

        struct Response {
            let people: People
        }
        
        struct ViewModel {
            let people: People
        }
    }
    
    enum UpdateStatus {
        
        struct Request { }
        
        struct Response { }
        
        struct ViewModel {
            let items: [Item]
        }
    }
    
}
