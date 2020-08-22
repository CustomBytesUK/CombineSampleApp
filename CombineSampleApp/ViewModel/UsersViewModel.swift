//
//  UsersViewModel.swift
//  CombineSampleApp
//
//  Created by Custom Bytes on 22/08/2020.
//  Copyright © 2020 Custom Bytes Ltd. All rights reserved.
//

import Foundation
import Combine

class UsersViewModel {
    
    var usersSubject = CurrentValueSubject<[User], Error>([]) // Empty array initial value
    
    private let apiManager: APIManagerProtocol
    private let endpoint: Endpoint
    
    init(apiManager: APIManagerProtocol, endpoint: Endpoint) {
        self.apiManager = apiManager
        self.endpoint = endpoint
    }
    
    func fetchUsers() {
        let url = URL(string: endpoint.urlString)!
        
        apiManager.fetchItems(url: url) { [weak self] (result: Result<[User], Error>) in
            switch result {
                case .success(let users):
                    self?.usersSubject.send(users)
                case .failure(let error):
                    self?.usersSubject.send(completion: .failure(error))
            }
        }
    }
    
    var title: String {
        "Users"
    }
}
