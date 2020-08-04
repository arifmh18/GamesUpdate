//
//  PublisherModel.swift
//  Games Update
//
//  Created by Muhammad Arif Hidayatulloh on 03/08/20.
//  Copyright © 2020 Ardat Tracode. All rights reserved.
//

import Foundation

struct PublisherModel : Codable {
    let count : Int?
    let next : String?
    let previous : String?
    let results : [DataPublisher]?

    struct DataPublisher : Codable {
        let id : Int?
        let name : String?
        let slug : String?
        let games_count : Int?
        let image_background : String?
        let games : [GamesPublisher]?
    }
    
    struct GamesPublisher : Codable {
        let id : Int?
        let slug : String?
        let name : String?
        let added : Int?
    }
}
