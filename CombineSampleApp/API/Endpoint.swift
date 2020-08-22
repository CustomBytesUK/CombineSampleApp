//
//  Endpoint.swift
//  CombineSampleApp
//
//  Created by Custom Bytes on 22/08/2020.
//  Copyright © 2020 Custom Bytes Ltd. All rights reserved.
//

import Foundation

enum Endpoint {
    case users
    
    var urlString: String {
        switch self {
            case .users:
                return "https://jsonplaceholder.typicode.com/users"
        }
    }
}
