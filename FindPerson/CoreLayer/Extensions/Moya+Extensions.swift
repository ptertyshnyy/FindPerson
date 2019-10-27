//
//  Moya+Extensions.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 24/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import Foundation
import Moya

public extension Response {
    
    func mapObject<T: Codable>(_ type: T.Type, path: String? = nil) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .millisecondsSince1970
        do {
            return try decoder.decode(T.self, from: try getJsonData(path))
        } catch {
            throw MoyaError.jsonMapping(self)
        }
    }

    func getJsonData(_ path: String? = nil) throws -> Data {
        do {
            var jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            if let path = path {
                
                guard let specificObject = jsonObject.value(forKeyPath: path) else {
                    throw MoyaError.jsonMapping(self)
                }
                
                jsonObject = specificObject as AnyObject
            }
            
            return try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        } catch {
            throw MoyaError.jsonMapping(self)
        }
    }
}

public extension MoyaProvider {
    
    @discardableResult
    internal func request<T: Codable>(
        _ target: Target,
        objectModel: T.Type,
        path: String? = nil,
        result: @escaping (_ returnData: Result<T, APIError>) -> Void
    ) -> Cancellable? {
        
        return request(target, completion: { [weak self] in
            guard let self = self else {
                return
            }
            
            if let error = $0.error {
                result(.failure(.network(error)))
                return
            }
            
            if let response = $0.value,
                let successResponse = try? response.filterSuccessfulStatusCodes() {
                do {
                    let returnData = try successResponse.mapObject(objectModel.self, path: path)
                    result(.success(returnData))
                } catch {
                    result(.failure(APIError.decoding(error)))
                }
            } else {
                if let data = $0.value?.data, let apiError = self.parseError(data: data) {
                    result(.failure(apiError))
                    return
                }
            }
        })
    }
    
    private func parseError(data: Data) -> APIError? {
        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
            let dict = jsonObject as? [String: Any],
            let apiError = APIError(dict: dict) {
            return apiError
        }
        return nil
    }
}
