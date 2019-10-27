//
//  Config.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 24/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import Foundation

internal class Config {
    
    static let shared: Config = .init()
    
    let apiUrl: URL = URL(string: "https://swapi.co/api")!
}
