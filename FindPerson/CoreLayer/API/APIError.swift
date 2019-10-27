//
//  APIError.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 24/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import Foundation
import Moya

internal enum APIError: Error {
    
    case network(Error)
    case decoding(Error)
    case internalMessage(String)
    
    case createRealmObjectError(Error)
    case fetchRealmObjectError(Error)
    
    init?(dict: [String: Any]) {
        if let code = dict["errorCode"] as? String {
            switch code {
            default:
                self = .internalMessage("Unknown error")
            }
            return
        }
        return nil
    }
}
