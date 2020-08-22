//
//  APIManager.swift
//  CombineSampleApp
//
//  Created by Custom Bytes on 22/08/2020.
//  Copyright © 2020 Custom Bytes Ltd. All rights reserved.
//

import Foundation
import Combine

protocol APIManagerProtocol {
    func fetchItems<T: Decodable> (url: URL, completion: @escaping (Result<[T], Error>) -> Void)
}

class APIManager: APIManagerProtocol {
    private let urlSession: URLSession
    
    private var subscribers = Set<AnyCancellable>()
    
    required init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func fetchItems<T: Decodable>(url: URL, completion: @escaping (Result<[T], Error>) -> Void) {
        urlSession.dataTaskPublisher(for: url)
            .map {$0.data}
            .decode(type: [T].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { (resultCompletion) in
                switch resultCompletion {
                    case .failure(let error):
                        completion(.failure(error))
                    case .finished:
                        break
                }
            }, receiveValue: { (resultArray) in
                completion(.success(resultArray))
            }).store(in: &subscribers)
    }
}
