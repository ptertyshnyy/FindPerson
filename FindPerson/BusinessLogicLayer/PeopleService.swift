//
//  PeopleService.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 24/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import Foundation
import Moya

internal protocol PeopleService {
    func getPeopleList(name: String, completion: @escaping (Result<[People], APIError>) -> Void)
}

internal class PeopleServiceImpl: PeopleService {

    // MARK: - Properties
    
    private let provider: MoyaProvider<API.People>
    
    // MARK: - Init
    
    init(provider: MoyaProvider<API.People>) {
        self.provider = provider
    }
    
    func getPeopleList(name: String, completion: @escaping (Result<[People], APIError>) -> Void) {
        let query = API.People.getPeople(name: name)
        provider.request(
            query,
            objectModel: API.People.Results.self)
        { [weak self] result in
            
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let result):
                let mappedPeople = self.mapPeople(result: result)
                completion(.success(mappedPeople))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func mapPeople(result: API.People.Results) -> [People] {
        
        let people: [People] = result.results.compactMap { person in
            guard
                let created = convertDate(date: person.created),
                let edited = convertDate(date: person.edited)
            else {
                return nil
            }
            
            let mappedGender = mapGender(gender: person.gender)
            
            return People(
                name: person.name,
                birthYear: person.birthYear,
                height: person.height,
                mass: person.mass,
                created: created,
                edited: edited,
                gender: mappedGender
            )
        }

        return people
    }
    
    private func mapGender(gender: String) -> Gender? {
        switch gender {
        case "male":
            return .male
        case "female":
            return .female
        case "unknown":
            return .unknown
        case "n/a":
            return .na
        default:
            return nil
        }
    }
    
    private func convertDate(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        return dateFormatter.date(from: date)
    }
}
