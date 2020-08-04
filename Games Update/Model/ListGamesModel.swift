//
//  ListGamesModel.swift
//  Games Update
//
//  Created by Muhammad Arif Hidayatulloh on 03/08/20.
//  Copyright © 2020 Ardat Tracode. All rights reserved.
//

import Foundation

struct ListGamesModel : Codable {
    let count : Int?
    let next : String?
    let previous : String?
    let results : [DataLists]?
    
    struct DataLists : Codable {
        let id : Int?
        let slug : String?
        let name : String?
        let released : String?
        let tba : Bool?
        let background_image : String?
        let rating : Double?
        let rating_top : Int?
        
    }
}
