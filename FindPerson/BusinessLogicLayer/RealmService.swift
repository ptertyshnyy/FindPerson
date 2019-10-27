//
//  RealmService.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 25/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import Foundation
import RealmSwift

internal protocol RealmService {
    func createPeople(people: [People], completion: @escaping (Result<Void, APIError>) -> Void)
    func fetchPeople(name: String, completion: @escaping ([People]) -> Void)
}

internal class RealmServiceImpl: RealmService {

    // MARK: - Properties
    
    private let realm = try! Realm()
    
    func createPeople(people: [People], completion: @escaping (Result<Void, APIError>) -> Void) {
        
        let peopleObjects = mapPeopleModels(people: people)
        
        do {
            try realm.write {
                realm.add(peopleObjects, update: .modified)
                completion(.success(()))
            }
        } catch let error {
            completion(.failure(.createRealmObjectError(error)))
        }
    }
    
    func fetchPeople(name: String, completion: @escaping ([People]) -> Void) {
        let predicate = NSPredicate(format: "name BEGINSWITH [c]%@", name)
        let peopleObjects = realm.objects(PeopleObject.self).filter(predicate)
        let mappedPeople = mapPeopleObjects(peopleObjects: Array(peopleObjects))
            
        completion(mappedPeople)
    }
    
    private func mapPeopleModels(people: [People]) -> [PeopleObject] {
        
        let peopleObjects: [PeopleObject] = people.map { people in
            let peopleObject = PeopleObject()
            peopleObject.name = people.name
            peopleObject.birthYear = people.birthYear
            peopleObject.height = people.height
            peopleObject.mass = people.mass
            peopleObject.created = people.created
            peopleObject.edited = people.edited
            peopleObject.gender = people.gender?.rawValue
            
            return peopleObject
        }
        
        return peopleObjects
    }
    
    private func mapPeopleObjects(peopleObjects: [PeopleObject]) -> [People] {
        let people: [People] = peopleObjects.map { people in
            return People(
                name: people.name,
                birthYear: people.birthYear,
                height: people.height,
                mass: people.mass,
                created: people.created,
                edited: people.edited,
                gender: mapGender(gender: people.gender)
            )
        }
        
        return people
    }
    
    private func mapGender(gender: String?) -> Gender? {
        switch gender {
        case "Мужчина":
            return .male
        case "Женщина":
            return .female
        case "Неисвестно":
            return .unknown
        case "n/a":
            return .na
        default:
            return nil
        }
    }
}
