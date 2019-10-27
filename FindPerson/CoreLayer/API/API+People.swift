//
//  API+People.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 24/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import Foundation
import Moya

extension API {
    
    enum People: TargetType {
        
        case getPeople(name: String)
        
        var baseURL: URL {
            return Config.shared.apiUrl
        }
        
        var path: String {
            switch self {
            case .getPeople:
                return "/people/"
            }
        }
        
        var method: Moya.Method {
            switch self {
            case .getPeople:
                return .get
            }
        }
        
        var sampleData: Data {
            return Data()
        }
        
        var task: Task {
            switch self {
            case .getPeople(let name):
                return .requestParameters(parameters: ["search": name], encoding: URLEncoding.queryString)
            }
        }
        
        var headers: [String : String]? {
            return nil
        }
    
    }
}

extension API.People {
    
    struct Results: Codable {
        let results: [People]
    }
    
    struct People: Codable {
        let name: String
        let birthYear: String
        let height: String
        let mass: String
        let created: String
        let edited: String
        let gender: String
    }
}
