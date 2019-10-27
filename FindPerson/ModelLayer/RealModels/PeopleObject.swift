//
//  PeopleObject.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 25/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import RealmSwift

internal class PeopleObject: Object {
    @objc dynamic var name = ""
    @objc dynamic var birthYear = ""
    @objc dynamic var height = ""
    @objc dynamic var mass = ""
    @objc dynamic var created = Date()
    @objc dynamic var edited = Date()
    @objc dynamic var gender: String?
    
    override class func primaryKey() -> String? { return "name" }
}
