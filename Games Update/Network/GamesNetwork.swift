//
//  GamesNetwork.swift
//  Games Update
//
//  Created by Muhammad Arif Hidayatulloh on 03/08/20.
//  Copyright © 2020 Ardat Tracode. All rights reserved.
//

import Foundation
import Moya

enum GamesNetwork {
    case listGame
    case listPublisher
    case gameDetail(id:Int)
}

extension GamesNetwork : TargetType {
    var baseURL: URL {
        return URL(string: "https://api.rawg.io/api/")!
    }
    
    var path: String {
        switch self {
        case .listGame:
            return "games"
        case .listPublisher:
            return "publishers"
        case .gameDetail(let id):
            return "games/\(id)"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        default:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type" : "application/json"
        ]
    }
        
}

private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
