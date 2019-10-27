//
//  People.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 24/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import Foundation

internal struct People {
    let name: String
    let birthYear: String
    let height: String
    let mass: String
    let created: Date
    let edited: Date
    let gender: Gender?
}

internal enum Gender: String {
    case male = "Мужчина"
    case female = "Женщина"
    case unknown = "Неисвестно"
    case na = "n/a"
}
